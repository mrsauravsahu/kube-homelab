valuesObj = { Values: { pv: {}, pvc: {} } }

valuesObj.Values.pv.enabled=""
valuesObj.Values.pv.name=""
valuesObj.Values.storageClassName=""
valuesObj.Values.storage=""
valuesObj.Values.pv.accessModes=""
valuesObj.Values.pv.path=""
valuesObj.Values.pv.nodeAffinity=""
valuesObj.Values.pvc.enabled=""
valuesObj.Values.pvc.name=""
valuesObj.Values.pv.name=""
valuesObj.Values.storage=""
valuesObj.Values.storageClassName=""

console.log(JSON.stringify(valuesObj, undefined, 2))