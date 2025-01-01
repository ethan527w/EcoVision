document.addEventListener('DOMContentLoaded', function () {
  const pages = document.querySelectorAll('.page');
  const navLinks = document.querySelectorAll('nav a');
  let totalEmission = 0;
  let emissionsByItem = {};
  let dailyEmissions = {};
  let map, startPoint, endPoint, distance, marker1, marker2;

  const emissionDatabase = {
    "Car": 0.27,
    "Bus": 0.1,
    "Underground": 0.05,
    "Electricity (kWh)": 0.233,
    "Flight (short-haul)": 0.254,
    // Add more items here
  };

  const searchBar = document.getElementById('searchBar');
  const searchResults = document.getElementById('searchResults');
  const searchItemCount = document.getElementById('searchItemCount');
  let selectedItem = null;

  searchBar.addEventListener('input', function() {
    const query = searchBar.value.toLowerCase();
    const matches = Object.keys(emissionDatabase).filter(item => item.toLowerCase().includes(query));
    displaySearchResults(matches);
  });

  function displaySearchResults(matches) {
    searchResults.innerHTML = '';
    matches.forEach(match => {
      const li = document.createElement('li');
      li.textContent = match;
      li.addEventListener('click', function() {
        selectedItem = match;
        searchBar.value = match;
        searchResults.innerHTML = '';
      });
      searchResults.appendChild(li);
    });
  }

  // External Links Page
  const externalLinks = [
    { name: 'World Carbon Emission Data', url: 'https://www.globalcarbonatlas.org/en/CO2-emissions' },
    { name: 'ESG Signup Table', url: 'https://sites.google.com/view/ethwu/home' },
    { name: 'SpeakNow NY', url: 'https://speaknowny.org/' },
    { name: 'Intuition Project', url: 'https://sites.google.com/view/intuitionproject/' },
    { name: 'Climate Action Resources', url: 'https://www.climaterealityproject.org/' }
  ];


  const externalLinksContainer = document.getElementById('page4');
  externalLinks.forEach(link => {
    const linkElement = document.createElement('a');
    linkElement.href = link.url;
    linkElement.textContent = link.name;
    linkElement.target = '_blank';  // Open in new tab
    externalLinksContainer.appendChild(linkElement);
    externalLinksContainer.appendChild(document.createElement('br'));
  });


  // Add item based on search
  document.getElementById('addSearchedItemBtn').addEventListener('click', function() {
    if (selectedItem) {
      const itemCount = parseInt(searchItemCount.value);
      const emission = emissionDatabase[selectedItem] * itemCount;
      totalEmission += emission;
      if (!emissionsByItem[selectedItem]) emissionsByItem[selectedItem] = 0;
      emissionsByItem[selectedItem] += emission;
      updateTotalEmission();
    } else {
      alert('Please select an item from the search results.');
    }
  });

  navLinks.forEach(link => {
    link.addEventListener('click', function (event) {
      event.preventDefault();
      const targetId = this.id.replace('link-', '');
      pages.forEach(page => page.classList.remove('active'));
      document.getElementById(targetId).classList.add('active');
      navLinks.forEach(link => link.classList.remove('active'));
      this.classList.add('active');
      if (targetId === 'page3') {
        updatePieChart();
      } else if (targetId === 'page5') {
        setTimeout(() => {
          initMap();
        }, 100);
      }
    });
  });

  // Reset button
  document.getElementById('resetBtn').addEventListener('click', function () {
    totalEmission = 0;
    emissionsByItem = {};
    updateTotalEmission();
    resetInputs();
  });

  // Add items to calculator
  document.querySelectorAll('.addItemBtn').forEach((button) => {
    button.addEventListener('click', function () {
      const row = button.closest('tr');
      const itemName = row.cells[0].textContent;
      const emissionPerUnit = parseFloat(row.cells[1].textContent);
      const itemCount = parseInt(row.querySelector('.itemCount').value);
      const emission = emissionPerUnit * itemCount;
      if (!emissionsByItem[itemName]) emissionsByItem[itemName] = 0;
      emissionsByItem[itemName] += emission;
      totalEmission += emission;
      updateTotalEmission();
    });
  });

  // Function to calculate the route and distance using Leaflet Routing Machine
  function calculateRoute() {
    L.Routing.control({
      waypoints: [
        L.latLng(startPoint.lat, startPoint.lng),
        L.latLng(endPoint.lat, endPoint.lng)
      ],
      routeWhileDragging: true,
      createMarker: function() { return null; }, // Hide markers
      lineOptions: {
        styles: [{ color: 'blue', weight: 4 }]
      },
      addWaypoints: false,
      show: false // Hide instructions
    }).on('routesfound', function(e) {
      const route = e.routes[0];
      const routeDistance = route.summary.totalDistance / 1000; // Convert to km
      document.getElementById('mapDistance').textContent = routeDistance.toFixed(2);

      const vehicle = document.getElementById('vehicle-select').value;
      if (emissionDatabase[vehicle]) {
        const emissionFactor = emissionDatabase[vehicle];
        const emission = emissionFactor * routeDistance;
        document.getElementById('mapEmission').textContent = emission.toFixed(2);
        totalEmission += emission;  // Update total emission
        updateTotalEmission();
      } else {
        console.error('Selected vehicle not found in emissionDatabase');
        document.getElementById('mapEmission').textContent = '0';
      }
    }).addTo(map);
  }


  // Add custom item
  document.getElementById('addCustomItemBtn').addEventListener('click', function () {
    const customItemName = document.getElementById('customItemName').value;
    const customItemEmission = parseFloat(document.getElementById('customItemEmission').value);
    const customItemCount = parseInt(document.getElementById('customItemCount').value);
    const emission = customItemEmission * customItemCount;
    if (!emissionsByItem[customItemName]) emissionsByItem[customItemName] = 0;
    emissionsByItem[customItemName] += emission;
    totalEmission += emission;
    updateTotalEmission();
  });

  // Save emissions to calendar
  document.getElementById('saveEmissionBtn').addEventListener('click', function () {
    const selectedDate = document.getElementById('dateInput').value;
    if (selectedDate && totalEmission > 0) {
      dailyEmissions[selectedDate] = totalEmission;
      alert(`Emission saved for ${selectedDate}: ${totalEmission.toFixed(2)} kg CO2`);
      resetInputs();
    } else {
      alert('Please enter a valid date and ensure emission is not zero.');
    }
  });

  // Update total emission display
  function updateTotalEmission() {
    document.getElementById('totalEmission').textContent = totalEmission.toFixed(2);
  }

  // Reset input fields
  function resetInputs() {
    document.querySelectorAll('.itemCount').forEach(input => input.value = 0);
    document.getElementById('customItemName').value = '';
    document.getElementById('customItemEmission').value = '';
    document.getElementById('customItemCount').value = 0;
  }

  // Pie chart for emissions by item
  let pieChart = null;
  function updatePieChart() {
    const ctx = document.getElementById('emissionPieChart').getContext('2d');
    const labels = Object.keys(emissionsByItem);
    const data = Object.values(emissionsByItem);
    if (pieChart) pieChart.destroy();
    pieChart = new Chart(ctx, {
      type: 'pie',
      data: {
        labels: labels,
        datasets: [{
          label: 'Emissions by Item',
          data: data,
          backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF'],
        }]
      }
    });
  }

  // Line chart for emission history
  document.getElementById('generateLineChart').addEventListener('click', function () {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    const ctx = document.getElementById('emissionLineChart').getContext('2d');
    const filteredEmissions = Object.entries(dailyEmissions).filter(([date]) => date >= startDate && date <= endDate);
    const labels = filteredEmissions.map(([date]) => date);
    const data = filteredEmissions.map(([, emission]) => emission);
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Daily Emissions (kg CO2)',
          data: data,
          fill: false,
          borderColor: 'rgb(75, 192, 192)',
          tension: 0.1
        }]
      }
    });
  });

  function initMap() {
    if (map) return;
    map = L.map('map').setView([51.505, -0.09], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(map);

    map.on('click', function (e) {
      if (!startPoint) {
        startPoint = e.latlng;
        marker1 = L.marker(startPoint).addTo(map).bindPopup('Start Point').openPopup();
      } else if (!endPoint) {
        endPoint = e.latlng;
        marker2 = L.marker(endPoint).addTo(map).bindPopup('End Point').openPopup();
        calculateRoute(); // Calculate the route instead of straight-line distance
      } else {
        resetMap();
      }
    });
  }

  // Function to calculate the route and distance using Leaflet Routing Machine
  function calculateRoute() {
    L.Routing.control({
      waypoints: [
        L.latLng(startPoint.lat, startPoint.lng),
        L.latLng(endPoint.lat, endPoint.lng)
      ],
      routeWhileDragging: true,
      createMarker: function() { return null; }, // Hide markers
      lineOptions: {
        styles: [{ color: 'blue', weight: 4 }]
      },
      addWaypoints: false,
      show: false // Hide instructions
    }).on('routesfound', function(e) {
      const route = e.routes[0];
      const routeDistance = route.summary.totalDistance / 1000; // Convert to km
      document.getElementById('mapDistance').textContent = routeDistance.toFixed(2);

      const vehicle = document.getElementById('vehicle-select').value;
      if (emissionDatabase[vehicle]) {
        const emission = emissionDatabase[vehicle] * routeDistance;
        document.getElementById('mapEmission').textContent = emission.toFixed(2);
        totalEmission += emission;  // Update total emission
        updateTotalEmission();
      } else {
        document.getElementById('mapEmission').textContent = '0';
      }
    }).addTo(map);
  }

  // Reset map functionality
  function resetMap() {
    if (marker1) map.removeLayer(marker1);
    if (marker2) map.removeLayer(marker2);
    if (startPoint) startPoint = null;
    if (endPoint) endPoint = null;
    map.eachLayer(layer => { if (layer instanceof L.Polyline) map.removeLayer(layer); });
    document.getElementById('mapDistance').textContent = '0';
    document.getElementById('mapEmission').textContent = '0';
  }

  document.getElementById('resetMapBtn').addEventListener('click', resetMap);
});
