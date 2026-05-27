namespace PhotoApp.DTOs
{
    public class PhotoResponseDto
    {
        public int Id { get; set; }

        public string Url { get; set; }

        public string? Description { get; set; }

        public int? AlbumId { get; set; }
    }
}