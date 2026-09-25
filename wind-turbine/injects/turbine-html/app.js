const connection = document.querySelector('.connection');
const connectionLabel = document.querySelector('#connection-label');
const connectionDot = document.querySelector('#connection-dot');
const rotor = document.querySelector('#rotor');
const turbineState = document.querySelector('#turbine-state');
const turbineStateLabel = document.querySelector('#turbine-state-label');
const speedValue = document.querySelector('#speed-value');
const directionValue = document.querySelector('#direction-value');
const directionName = document.querySelector('#direction-name');
const temperatureValue = document.querySelector('#temperature-value');
const speedProgress = document.querySelector('#speed-progress');
const temperatureProgress = document.querySelector('#temperature-progress');
const directionNeedle = document.querySelector('#direction-needle');
const lastUpdate = document.querySelector('#last-update');

let reconnectTimer;
let reconnectDelay = 1000;

function setConnectionState(state, label) {
  connection.className = `connection ${state}`;
  connectionLabel.textContent = label;
  connectionDot.title = label;
}

function setProgress(circle, ratio) {
  const circumference = 2 * Math.PI * 43;
  const clampedRatio = Math.max(0, Math.min(1, ratio));
  circle.style.strokeDasharray = circumference;
  circle.style.strokeDashoffset = circumference * (1 - clampedRatio);
}

function compassPoint(degrees) {
  const points = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return points[Math.round(degrees / 45) % points.length];
}

function updateDashboard(data) {
  const tags = data.points.reduce((accum, curr) => {
    accum[curr.tag] = curr.value;
    return accum;
  }, {});

  const speed = Number(tags["speed.high"]);
  const direction = Number(tags["dir.high"]);
  const temperature = Number(tags["temp.high"]);
  const feathered = Boolean(tags["feathered"]);

  if (![speed, direction, temperature].every(Number.isFinite)) return;

  speedValue.textContent = speed.toFixed(1);
  directionValue.textContent = Math.round(direction).toString().padStart(3, '0');
  directionName.textContent = `${compassPoint(direction)} / meteorological heading`;
  temperatureValue.textContent = temperature.toFixed(1);
  setProgress(speedProgress, speed / 25);
  setProgress(temperatureProgress, (temperature + 20) / 60);
  directionNeedle.style.transform = `rotate(${direction}deg)`;

  rotor.classList.toggle('is-running', !feathered);
  turbineState.classList.toggle('feathered', feathered);
  turbineState.classList.toggle('running', !feathered);
  turbineStateLabel.textContent = feathered ? 'Feathered' : 'Generating';
  lastUpdate.textContent = data.timestamp ? new Date(data.timestamp).toLocaleTimeString() : 'Just now';
}

function connect() {
  clearTimeout(reconnectTimer);
  setConnectionState('', 'Connecting');

  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
  const socket = new WebSocket(`${protocol}//${window.location.host}/api/v1/query/ws`);

  socket.addEventListener('open', () => {
    reconnectDelay = 1000;
    setConnectionState('connected', 'Live connection');
  });

  socket.addEventListener('message', (event) => {
    try {
      updateDashboard(JSON.parse(event.data));
    } catch (error) {
      console.error('Unable to read telemetry message', error);
    }
  });

  socket.addEventListener('error', () => {
    setConnectionState('error', 'Connection error');
  });

  socket.addEventListener('close', () => {
    setConnectionState('error', 'Reconnecting');
    reconnectTimer = setTimeout(connect, reconnectDelay);
    reconnectDelay = Math.min(reconnectDelay * 2, 10000);
  });
}

connect();
