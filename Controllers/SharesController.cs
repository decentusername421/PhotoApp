using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhotoApp.Data;
using PhotoApp.DTOs;
using PhotoApp.Models;
using System.Security.Claims;

namespace PhotoApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class SharesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SharesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> SharePhoto(
            SharePhotoDto dto)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var photo = await _context.Photos
                .FirstOrDefaultAsync(p =>
                    p.Id == dto.PhotoId &&
                    p.UserId == userId);

            if (photo == null)
            {
                return NotFound("Photo not found.");
            }

            var userExists = await _context.Users
                .AnyAsync(u =>
                    u.Id == dto.SharedWithUserId);

            if (!userExists)
            {
                return NotFound("User not found.");
            }

            var share = new Share
            {
                PhotoId = dto.PhotoId,
                SharedWithUserId = dto.SharedWithUserId
            };

            _context.Shares.Add(share);

            await _context.SaveChangesAsync();

            return Ok("Photo shared.");
        }

        [HttpGet]
        public async Task<IActionResult> GetSharedPhotos()
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var shares = await _context.Shares
                .Include(s => s.Photo)
                .Where(s => s.SharedWithUserId == userId)
                .ToListAsync();

            return Ok(shares);
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShare(int id)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var share = await _context.Shares
                .Include(s => s.Photo)
                .FirstOrDefaultAsync(s =>
                    s.Id == id &&
                    s.Photo.UserId == userId);

            if (share == null)
            {
                return NotFound("Share not found.");
            }

            _context.Shares.Remove(share);

            await _context.SaveChangesAsync();

            return Ok("Share removed.");
        }
    }
}