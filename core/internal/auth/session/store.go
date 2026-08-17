package session

type Store interface {
	Create(session *Session) error
	GetByID(id uint) (*Session, error)
	GetByRefreshHashed(hashed string) (*Session, error)
	Update(session *Session) error
	Delete(id uint) error
}
