using Microsoft.AspNetCore.Http;

namespace PhotoApp.DTOs
{
    public class UploadPhotoDto
    {
        public string? Description { get; set; }

        public IFormFile File { get; set; }
    }
}