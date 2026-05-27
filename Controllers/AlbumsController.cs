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
    public class AlbumsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AlbumsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetAlbums()
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var albums = await _context.Albums
                .Include(a => a.Photos)
                .Where(a => a.UserId == userId)
                .ToListAsync();

            return Ok(albums);
        }

        [HttpPost]
        public async Task<IActionResult> CreateAlbum(
    CreateAlbumDto dto)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var existingAlbum = await _context.Albums
                .AnyAsync(a =>
                    a.Name == dto.Name &&
                    a.UserId == userId);

            if (existingAlbum)
            {
                return BadRequest("Album already exists.");
            }

            var album = new Album
            {
                Name = dto.Name,
                UserId = userId
            };

            _context.Albums.Add(album);

            await _context.SaveChangesAsync();

            return Ok(album);
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAlbum(int id)
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier));

            var album = await _context.Albums
                .Include(a => a.Photos)
                .FirstOrDefaultAsync(a =>
                    a.Id == id &&
                    a.UserId == userId);

            if (album == null)
            {
                return NotFound("Album not found.");
            }

            foreach (var photo in album.Photos)
            {
                photo.AlbumId = null;
            }

            _context.Albums.Remove(album);

            await _context.SaveChangesAsync();

            return Ok("Album deleted.");
        }
    }
}