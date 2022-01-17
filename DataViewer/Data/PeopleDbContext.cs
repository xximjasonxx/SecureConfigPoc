using System;
using Microsoft.EntityFrameworkCore;

namespace DataViewer.Data
{
    public class PeopleDbContext : DbContext
    {
        public DbSet<Person> People { get; set; }

        public PeopleDbContext(DbContextOptions<PeopleDbContext> options) : base(options)
        {
            Database.Migrate();
        }
    }
}
