import * as t2d2 from '@t2d2/core';

describe("resources", () => {
  let profile: t2d2.Profile;
  let currentState: t2d2.ParsedTFPlan;

  beforeAll(async () => {
    profile = await t2d2.init({
      profileName: 'resources',
      workspaceDir: 'iac',
    })

    currentState = await t2d2.plan(profile, {})
  })

  it("should create a base namespace", () => {
    const baseNamespace = currentState.getResourceByAddress("kubernetes_namespace.homelab_ns")
    expect(baseNamespace).not.toBeNull()
    expect((baseNamespace as any).values.metadata[0].name).toBe("homelab")
  })
})
