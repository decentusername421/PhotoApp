namespace PhotoApp.Models
{
    public class Album
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public int UserId { get; set; }

        public User User { get; set; }

        public List<Photo> Photos { get; set; }
    }
}