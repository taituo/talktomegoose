async function loadBriefing() {
  try {
    const response = await fetch('http://localhost:3001/api/briefings/current');
    if (!response.ok) {
      throw new Error(`Request failed: ${response.status}`);
    }
    const data = await response.json();
    const section = document.querySelector('#briefings');
    section.innerHTML = `
      <h2>Mission Briefings</h2>
      <p><strong>${data.mission}</strong></p>
      <ul>${data.objectives.map((item) => `<li>${item}</li>`).join('')}</ul>
      <p><em>ETA: ${data.eta}</em></p>
    `;
  } catch (error) {
    console.error('Failed to load mission briefing', error);
  }
}

document.addEventListener('DOMContentLoaded', loadBriefing);
