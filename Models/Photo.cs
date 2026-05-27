namespace PhotoApp.Models
{
    public class Photo
    {
        public int Id { get; set; }

        public string Url { get; set; }

        public int UserId { get; set; }

        public User User { get; set; }

        public int? AlbumId { get; set; }

        public Album? Album { get; set; }
        public string? Description { get; set; }
    }
}
