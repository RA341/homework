package users

type Store interface {
	List() ([]User, error)
	Create(user *User) error
	Delete(id uint) error
	Edit(user *User) error
}
