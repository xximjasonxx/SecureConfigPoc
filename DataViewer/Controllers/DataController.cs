using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataViewer.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace DataViewer.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DataController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly PeopleDbContext _context;

        public DataController(IConfiguration configuration, PeopleDbContext peopleDbContext)
        {
            _configuration = configuration;
            _context = peopleDbContext;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var values = new List<string>();
            values.Add("Hello World");
            values.Add(_configuration["searchAddress"]);
            values.Add(_configuration["sensitive-value"]);

            var people = await _context.People.ToListAsync();
            values.AddRange(people.Select(x => $"{x.FirstName} {x.LastName}"));

            return Ok(values);
        }
    }
}
