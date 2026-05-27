using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhotoApp.Data;
using PhotoApp.Models;
using System.Security.Claims;
using PhotoApp.DTOs;

namespace PhotoApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PhotosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PhotosController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetPhotos()
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var photos = await _context.Photos
                .Where(p => p.UserId == userId)
                .Select(p => new PhotoResponseDto
                {
                    Id = p.Id,
                    Url = p.Url,
                    Description = p.Description,
                    AlbumId = p.AlbumId
                })
                .ToListAsync();

            return Ok(photos);
        }

        [HttpPost]
        public async Task<IActionResult> AddPhoto(CreatePhotoDto dto)
        {
            var userId = int.Parse(
    User.FindFirstValue(ClaimTypes.NameIdentifier));

            var photo = new Photo
            {
                Url = dto.Url,

                UserId = userId
            };

            _context.Photos.Add(photo);

            await _context.SaveChangesAsync();

            return Ok(photo);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePhoto(int id)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var photo = await _context.Photos
                .FirstOrDefaultAsync(p =>
                    p.Id == id &&
                    p.UserId == userId);

            if (photo == null)
            {
                return NotFound();
            }

            _context.Photos.Remove(photo);

            await _context.SaveChangesAsync();

            return Ok("Photo deleted.");
        }

        [HttpPost("upload")]
        public async Task<IActionResult> UploadPhoto(
    [FromForm] UploadPhotoDto dto)
        {
            if (dto.File == null || dto.File.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var uploadsFolder = Path.Combine(
                Directory.GetCurrentDirectory(),
                "Uploads");

            if (!Directory.Exists(uploadsFolder))
            {
                Directory.CreateDirectory(uploadsFolder);
            }

            var fileName = Guid.NewGuid().ToString()
                + Path.GetExtension(dto.File.FileName);

            var filePath = Path.Combine(
                uploadsFolder,
                fileName);

            using (var stream = new FileStream(
                filePath,
                FileMode.Create))
            {
                await dto.File.CopyToAsync(stream);
            }

            var photo = new Photo
            {
                Url = "/Uploads/" + fileName,
                Description = dto.Description,
                UserId = userId
            };

            _context.Photos.Add(photo);

            await _context.SaveChangesAsync();

            return Ok(photo);
        }


        [HttpPut("{photoId}/album/{albumId}")]
        public async Task<IActionResult> AddPhotoToAlbum(
            int photoId,
            int albumId)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var photo = await _context.Photos
                .FirstOrDefaultAsync(p =>
                    p.Id == photoId &&
                    p.UserId == userId);

            if (photo == null)
            {
                return NotFound("Photo not found.");
            }

            var album = await _context.Albums
                .FirstOrDefaultAsync(a =>
                    a.Id == albumId &&
                    a.UserId == userId);

            if (album == null)
            {
                return NotFound("Album not found.");
            }

            photo.AlbumId = albumId;

            await _context.SaveChangesAsync();

            return Ok("Photo added to album.");
        }

    }
}