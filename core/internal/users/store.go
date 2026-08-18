package users

type Store interface {
	List() ([]User, error)
	Create(user *User) error
	Delete(id uint) error
	Edit(user *User) error
	GetByUsername(username string) (*User, error)
	GetById(id uint) (*User, error)
	Count() (int, error)
}
