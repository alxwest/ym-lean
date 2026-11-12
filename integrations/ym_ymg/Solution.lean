import YMGBridge.Translation
import YMGSubmission.Solution

set_option autoImplicit false
set_option warningAsError true

namespace YMGBridge
universe u

/-- The original proof, translated through a proved equivalence. The universe
occurs in the carrier of the presented group; it is not an unused parameter.
This does not assert `YangMills.YangMillsExistenceOnly`. -/
theorem jointExistence : PresentedJointExistence.{u} :=
  presentedJointExistence_iff_source.mpr YMGSubmission.jointExistence

end YMGBridge
