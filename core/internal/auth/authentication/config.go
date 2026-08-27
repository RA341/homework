package authentication

type Config struct {
	JwtSecret            string
	JwtIssuer            string
	sessionExpiryInHours int
}
