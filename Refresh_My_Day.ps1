$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = "Stop"

# KROK 1: Cas
$DateStr = Get-Date -Format "MMMM dd, yyyy HH:mm:ss"



# KROK 3: Hacker News
try {
    $hnData = Invoke-RestMethod -Uri "https://hacker-news.firebaseio.com/v0/topstories.json"
    $hnItems = $hnData | Select-Object -First 3
    $hnHtml = ""
    foreach ($item in $hnItems) {
        $story = Invoke-RestMethod -Uri "https://hacker-news.firebaseio.com/v0/item/$($item).json"
        $hnHtml += "<li class='mb-2 text-sm'><a href='$($story.url)' target='_blank' class='text-blue-400 hover:text-blue-300'>$($story.title)</a> <button class=`"save-btn ml-2 text-xs text-green-400 font-bold`" data-source=`"HN`">[Save]</button><p class='text-xs text-gray-500 mt-1 mb-3'>Score: $($story.score)</p></li>"
    }
} catch {
    $hnHtml = "<li>Failed to fetch Hacker News.</li>"
}

# KROK 4: GitHub
try {
    $date = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
    $gitData = Invoke-RestMethod -Uri "https://api.github.com/search/repositories?q=created:>$date&sort=stars&order=desc" -Headers @{"User-Agent"="PowerShell"}
    $gitItems = $gitData.items | Select-Object -First 3
    $gitHtml = ""
    foreach ($repo in $gitItems) {
        $desc = $repo.description
        if ([string]::IsNullOrWhiteSpace($desc)) { $desc = "No description." }
        $gitHtml += "<li class='mb-2 text-sm'><a href='$($repo.html_url)' target='_blank' class='text-blue-400 hover:text-blue-300'>$($repo.full_name)</a> <button class=`"save-btn ml-2 text-xs text-green-400 font-bold`" data-source=`"GIT`">[Save]</button><p class='text-xs text-gray-500 mt-1 mb-3 line-clamp-2'>$desc</p></li>"
    }
} catch {
    $gitHtml = "<li>Failed to fetch GitHub trends.</li>"
}

# KROK 5: JS
$jsCode = @"
<script>
document.addEventListener('click', function(e) {
  if(e.target && e.target.classList.contains('save-btn')) {
    let src = e.target.getAttribute('data-source') || 'WEB';
    let li = e.target.closest('li'); if(!li) return;
    let link = li.querySelector('a');
    if(link) {
      let t = link.innerText; let u = link.href;
      let v = JSON.parse(localStorage.getItem('aiVault')) || [];
      if(!v.some(i => i.url === u)) { v.push({title: t, url: u, source: src}); localStorage.setItem('aiVault', JSON.stringify(v)); renderVault(); }
    }
  }
  if(e.target && e.target.classList.contains('del-btn')) {
    let u = e.target.getAttribute('data-url');
    let v = JSON.parse(localStorage.getItem('aiVault')) || [];
    v = v.filter(i => i.url !== u); localStorage.setItem('aiVault', JSON.stringify(v)); renderVault();
  }
});
function renderVault() {
  let v = JSON.parse(localStorage.getItem('aiVault')) || [];
  let colors = { 'HN': 'text-orange-400', 'GIT': 'text-gray-300', 'WEB': 'text-purple-400' };
  let h = v.map(i => {
    let c = colors[i.source] || 'text-gray-400';
    return '<li class="mb-2 text-sm"><span class="text-xs font-bold mr-2 '+c+'">['+(i.source || 'UNK')+']</span><a href="'+i.url+'" target="_blank" class="text-blue-400 hover:text-blue-300">'+i.title+'</a> <button class="del-btn text-red-500 ml-2 font-bold" data-url="'+i.url+'">[X]</button></li>';
  }).join('');
  let vl = document.getElementById('vault-list'); if(vl) { vl.innerHTML = h || '<p class="text-gray-500 text-xs mt-2">Vault is empty.</p>'; }
}
window.onload = renderVault;

async function liveScrape() {
  let url = document.getElementById('live-url').value;
  let res = document.getElementById('scrape-result');
  if(!url) return;
  res.innerHTML = '<span class="text-yellow-500">Extracting data via Jina AI...</span>';
  try {
    let response = await fetch('https://r.jina.ai/' + url);
    if(!response.ok) throw new Error('Network response was not ok');
    let text = await response.text();
    res.innerText = text.substring(0, 2500) + (text.length > 2500 ? '\n\n[TEXT TRUNCATED...]' : '');
  } catch (error) {
    res.innerHTML = '<span class="text-red-500">Extraction failed: ' + error.message + ' (Possible CORS block by target)</span>';
  }
}
</script>
"@

# KROK 6: HTML Layout
$FullHTML = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard v9.3</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#0a0a0a] text-gray-300 font-sans p-8">
    <h1 class="text-4xl font-bold text-white mb-2">Executive AI Briefing</h1>
    <p class="text-gray-500 mb-8">$DateStr</p>

    <div class="max-w-screen-2xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-6 mt-10">
        <div class="bg-[#111111] border border-gray-800 p-6 rounded-xl shadow-lg">
            <h2 class="text-lg font-bold mb-4 text-white uppercase tracking-wider">AI Radar</h2>
            <ul>$hnHtml</ul>
        </div>
        <div class="bg-[#111111] border border-gray-800 p-6 rounded-xl shadow-lg">
            <h2 class="text-lg font-bold mb-4 text-white uppercase tracking-wider">GitHub Trends</h2>
            <ul>$gitHtml</ul>
        </div>
        <div class="bg-[#111111] border border-gray-800 p-6 rounded-xl shadow-lg">
            <h2 class="text-lg font-bold mb-4 text-white uppercase tracking-wider">Persistent Vault</h2>
            <ul id="vault-list"></ul>
        </div>
    </div>

    <div class="mt-8 bg-[#111111] border border-gray-800 p-6 rounded-xl shadow-lg">
        <h2 class="text-lg font-bold mb-4 text-white uppercase tracking-wider">Live AI Scraper (Jina Reader)</h2>
        <div class="flex gap-2 mb-4">
            <input type="text" id="live-url" placeholder="Paste URL here..." class="w-full bg-black border border-gray-700 text-gray-300 px-4 py-2 rounded focus:outline-none focus:border-green-500">
            <button onclick="liveScrape()" class="bg-green-700 hover:bg-green-600 text-white px-6 py-2 rounded font-bold transition">Analyze</button>
        </div>
        <div id="scrape-result" class="text-sm text-gray-400 font-mono whitespace-pre-wrap max-h-96 overflow-y-auto">Waiting for input...</div>
    </div>

    <div class="mt-12 text-center text-xs text-gray-600 border-t border-gray-800 pt-4 pb-4"><span class="text-green-500 font-bold">[ OK ] All Systems Operational</span> | Last Sync: $DateStr | Engine: Jina AI Extraction</div>

    $jsCode
</body>
</html>
"@

# KROK 7: Ulozenie a Spustenie
[System.IO.File]::WriteAllText("c:\Users\a\Desktop\AI_Morning_Briefing.html", $FullHTML, (New-Object System.Text.UTF8Encoding($False)))
Invoke-Item "c:\Users\a\Desktop\AI_Morning_Briefing.html"
