public protocol AuthorizationServiceInterface: AnyObject {
    func signIn()
    func fetchUserStatus(phone: String) async throws -> UserRoleStatus
    func registerNewAccount(phone: String, name: String) async throws -> Bool
    func otpRequest(phone: String) async throws -> Bool
    func otpVerify(phone: String, otp: String) async throws -> Bool
}
