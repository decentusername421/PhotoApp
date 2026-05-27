namespace PhotoApp.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Username { get; set; }

        public string Email { get; set; }

        public string PasswordHash { get; set; }

        public List<Photo> Photos { get; set; }

        public List<Album> Albums { get; set; }
    }
}