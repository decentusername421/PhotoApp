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
    }
}