const crypto = require('crypto');
const fetch = require('node-fetch');

// MinIO configuration
const endpoint = 'http://minio.homelab.svc.cluster.local:9000'; // Replace with your Minio server URL
const accessKey = '5GmxSatOpNHSHd8mLW3u';  // Replace with your Minio access key
const secretKey = 'NYwjcZoDgHmDUdKSfCFg52kS5pk5bZBvHovEG1xi';  // Replace with your Minio secret key
const bucketName = 'n8n-sbx'; // Replace with your Minio bucket name

// Function to create a date in AWS format
function getAmzDate() {
    const date = new Date();
    return date.toISOString().replace(/[:\-]|\.\d{3}/g, '').replace(/T/, 'Z').slice(0, 16);
}

// Function to create a date in YYYYMMDD format
function getDateStamp() {
    const date = new Date();
    return date.toISOString().replace(/-/g, '').slice(0, 8);
}

// Function to create the signature key
function getSignatureKey(key, dateStamp, regionName, serviceName) {
    const kDate = crypto.createHmac('sha256', 'AWS4' + key).update(dateStamp).digest();
    const kRegion = crypto.createHmac('sha256', kDate).update(regionName).digest();
    const kService = crypto.createHmac('sha256', kRegion).update(serviceName).digest();
    return crypto.createHmac('sha256', kService).update('aws4_request').digest();
}

// Function to create the authorization header
function createAuthorizationHeader(accessKey, secretKey, amzDate, dateStamp, regionName, serviceName, canonicalRequest) {
    const credentialScope = `${dateStamp}/${regionName}/${serviceName}/aws4_request`;
    const stringToSign = `AWS4-HMAC-SHA256\n${amzDate}\n${credentialScope}\n${crypto.createHash('sha256').update(canonicalRequest).digest('hex')}`;
    const signingKey = getSignatureKey(secretKey, dateStamp, regionName, serviceName);
    const signature = crypto.createHmac('sha256', signingKey).update(stringToSign).digest('hex');
    return `AWS4-HMAC-SHA256 Credential=${accessKey}/${credentialScope}, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=${signature}`;
}

var promises = [];
// Get the file data from the n8n workflow provides the file data
// Loop through the items and upload each file to MinIO
for (const item of $input.all()) {
    // const filePath = item.; // Path to the file to upload
    const fileName = item.binary.data.fileName; // Name of the file in Minio
    // res.push({bruh: item});
    // continue;

    // const fileData = atob(item.binary.data.data)
    const fileData = Buffer.from(item.binary.data.data, 'base64').toString()

    const amzDate = getAmzDate();
    const dateStamp = getDateStamp();
    const regionName = 'us-east-1';
    const serviceName = 's3';
    const canonicalUri = `/${bucketName}/${fileName}`;
    const canonicalQueryString = '';
    const canonicalHeaders = `host:${endpoint.replace('https://', '')}\nx-amz-content-sha256:${crypto.createHash('sha256').update(fileData).digest('hex')}\nx-amz-date:${amzDate}\n`;
    const signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
    const payloadHash = crypto.createHash('sha256').update(fileData).digest('hex');
    const canonicalRequest = `PUT\n${canonicalUri}\n${canonicalQueryString}\n${canonicalHeaders}\n${signedHeaders}\n${payloadHash}`;
    const authorizationHeader = createAuthorizationHeader(accessKey, secretKey, amzDate, dateStamp, regionName, serviceName, canonicalRequest);

    console.log(canonicalRequest)

    // Upload the file using fetch
    promises.push(new Promise((resolve, reject) => {
        fetch(`${endpoint}/${bucketName}/${fileName}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'text/plain',
                'x-amz-date': amzDate,
                'x-amz-content-sha256': payloadHash,
                'Authorization': authorizationHeader,
            },
            body: fileData,
        })
            .then(response => {
                if (response.ok) {
                    console.log(`File ${ fileName } uploaded successfully.`);

                    resolve({ json: { message: "pass" } });
                } else {
                    let message = `Failed to upload file ${ fileName }: ${ response.statusText }`
                    reject(message);
                    resolve({ json: { message: "fail", details: message } });
                }
            })
            .catch(error => {
                let message = `Error uploading file ${ fileName }: ${ error }`
                reject(message);
                resolve({ json: { message: "fail", details: message } });
            });
        }))
    }

    return Promise.allSettled(promises)
