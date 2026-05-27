namespace PhotoApp.Models
{
    public class Share
    {
        public int Id { get; set; }

        public int PhotoId { get; set; }

        public Photo Photo { get; set; }

        public int SharedWithUserId { get; set; }

        public User SharedWithUser { get; set; }
    }
}