'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d6c3b8eb1923337c387ed35fdfe159ad",
"assets/AssetManifest.bin.json": "ad343b41d8925f2f8e077fa256ec8bfd",
"assets/AssetManifest.json": "29e42c96b948385c85a225909f5a42cf",
"assets/assets/ANAK%2520KAILAN.png": "11204f8aa743ba5edd238e8e1deff0cc",
"assets/assets/Baby%2520Kailan.png": "e42eeaa02da0462945d670891a622626",
"assets/assets/Baby%2520Susu.png": "9e569044a6257ccfe2c8404f0cde3c60",
"assets/assets/Basil.png": "6635032ba2fa2c5c07691ef3ef8e4f83",
"assets/assets/Bayam%2520merah.png": "51e65b3ff440613c9e5bea2ec96be479",
"assets/assets/Bayam.png": "51e65b3ff440613c9e5bea2ec96be479",
"assets/assets/Beetroot.png": "310977a2ffed0b14c15e9ca5f87017ea",
"assets/assets/BETROOT.png": "099ea3e3c8f022b54fe0d3e2f9745914",
"assets/assets/Broccoli.png": "b37d105a9ca2f618e48e6d060dd10ddd",
"assets/assets/Cabbage%2520(A).png": "93820888e1028dcdf5bec419a37104e2",
"assets/assets/Cabbage%2520(B).png": "93820888e1028dcdf5bec419a37104e2",
"assets/assets/Cabbage%2520(M).png": "93820888e1028dcdf5bec419a37104e2",
"assets/assets/Cabbage%2520Bunga.png": "93820888e1028dcdf5bec419a37104e2",
"assets/assets/Capsicum%2520Green%2520(A).png": "2363aef062ebb95a43d11143e5065cc0",
"assets/assets/Capsicum%2520Green%2520(B).png": "2363aef062ebb95a43d11143e5065cc0",
"assets/assets/CAPSICUM%2520GREEN.png": "2363aef062ebb95a43d11143e5065cc0",
"assets/assets/Capsicum%2520Red%2520(A).png": "f822f6ebf263339ee0694934c6d9ae1b",
"assets/assets/Capsicum%2520Red%2520(B).png": "f822f6ebf263339ee0694934c6d9ae1b",
"assets/assets/CAPSICUM%2520RED.png": "f822f6ebf263339ee0694934c6d9ae1b",
"assets/assets/Capsicum%2520Yellow%2520(A).png": "1b78cbb49208ce41435524705a4a30c6",
"assets/assets/Capsicum%2520Yellow%2520(B).png": "1b78cbb49208ce41435524705a4a30c6",
"assets/assets/CAPSICUM%2520YELLOW.png": "1b78cbb49208ce41435524705a4a30c6",
"assets/assets/Carrot%2520A.png": "7accc10c7006bfa71cecd9f0b0f9a2be",
"assets/assets/Carrot%2520B.png": "7accc10c7006bfa71cecd9f0b0f9a2be",
"assets/assets/Cauliflower.png": "1d56dd9b442ce3662c4c4fa2b878679a",
"assets/assets/Cherry%2520A.png": "ac36805c0150bb91dc19c1373c53a846",
"assets/assets/Cherry%2520B.png": "ac36805c0150bb91dc19c1373c53a846",
"assets/assets/Cherry%2520Tomato%2520-%2520RED.png": "ebf14f67f115475196778f1a9cb1c121",
"assets/assets/Cherry%2520Tomato%2520-%2520YELLOW.png": "c83fc34eee97805b422a33c0ea23583e",
"assets/assets/CHERRY%2520TOMATO.png": "ebf14f67f115475196778f1a9cb1c121",
"assets/assets/Chinese%2520Cabbage%2520(A).png": "9e569044a6257ccfe2c8404f0cde3c60",
"assets/assets/Chinese%2520Cabbage%2520(B).png": "9e569044a6257ccfe2c8404f0cde3c60",
"assets/assets/CHINESE%2520CABBAGE.png": "873a76dba27b05f06ab68c355326d8e3",
"assets/assets/Chives%2520-%2520Big.png": "c4fbcbd4ac7fde419e3879359d64c35f",
"assets/assets/Chives%2520-%2520Small.png": "c4fbcbd4ac7fde419e3879359d64c35f",
"assets/assets/CILI%2520HIJAU.png": "92ee62cb37b9f7ec81c8f3e68ae0e342",
"assets/assets/CILI%2520MERAH.png": "9861a2a0203b158b4bd95782c7d11928",
"assets/assets/DAUN%2520BAWANG.png": "87d1ad151b23e9a6580b53ad04b3a204",
"assets/assets/DAUN%2520INSAI.png": "0a54d6f8a3743be533ff3869dbc963c7",
"assets/assets/DAUN%2520PUDINA.png": "c99de8e6043fa1346c838387ebafeca6",
"assets/assets/Daun%2520Soup.png": "4fee4e4f757d14cd664490d16f4c35d8",
"assets/assets/DAUN%2520SUP.png": "4fee4e4f757d14cd664490d16f4c35d8",
"assets/assets/Daun%2520Ubi.png": "03170d004940e181ba642c6fc2ac09fa",
"assets/assets/Egg%2520Plant.png": "c9479a8dee29d0d2064b89fc22254653",
"assets/assets/Flat%2520Bean-%2520Long.png": "c84fd28af13b51e22ab84971794db741",
"assets/assets/Flat%2520Bean.png": "c84fd28af13b51e22ab84971794db741",
"assets/assets/French%2520Bean%2520(B).png": "c84fd28af13b51e22ab84971794db741",
"assets/assets/French%2520Beans%2520(A).png": "c84fd28af13b51e22ab84971794db741",
"assets/assets/Garlic%2520pealed.png": "f3ecefbaa7585717f15375c49c78a5e4",
"assets/assets/gif/live.gif": "676fc662e399a5cc0e11deab169efb7f",
"assets/assets/Green%2520Chilli%2520(A).png": "92ee62cb37b9f7ec81c8f3e68ae0e342",
"assets/assets/Green%2520Chilli%2520(B).png": "92ee62cb37b9f7ec81c8f3e68ae0e342",
"assets/assets/GREEN%2520CORAL.png": "60140e9c916be803105158f517a150a9",
"assets/assets/Halia%2520muda.png": "47f9b86fce4188da3e79c96eb3e21d56",
"assets/assets/Iceberg.png": "99c66b6dd1f24f9dd223be9d1f9c9d87",
"assets/assets/Icikuwa.png": "eff62062f02944819572084f554eeae0",
"assets/assets/icon.png": "6353ec94513cb6fdae4ae2dd718b971c",
"assets/assets/Insai%2520-%2520Coriander.png": "0a54d6f8a3743be533ff3869dbc963c7",
"assets/assets/JAGUNG%2520MUTIARA%2520(WHITE%2520CORN).png": "06f1f28d311e887bcbdf1b1d1987d49c",
"assets/assets/KACANG%2520BUNCIS%2520(FRENCH%2520BEANS).png": "3d8efd53483c9e2afd2e222978009def",
"assets/assets/Kacang%2520panjang.png": "fc83d1e1c1d1e53993f39e5aafac9574",
"assets/assets/KAICHOY.png": "9156e351daaa92920ac9336ca4afdc07",
"assets/assets/KAILAN%2520CAMERON.png": "73d66f27de8b327c42b824084c5116b5",
"assets/assets/Kang%2520kung.png": "827c6725cf13a2e28a65436a21e29e1a",
"assets/assets/KUCAI.png": "7c1f6f8c0182fa88f0cab70e73effc3c",
"assets/assets/Kunyit.png": "90baf7b63911542875bfb09576ebdf0f",
"assets/assets/Labu%2520air.png": "9837082d9625654511859ca4b1bf01ac",
"assets/assets/LABU%2520CAMERON.png": "9837082d9625654511859ca4b1bf01ac",
"assets/assets/Lady%2520finger.png": "361c3ae05bd6a17f8abd7f190c661fe1",
"assets/assets/leaves.jpg": "35c4a7b30edd206d5c07e6c8f154578b",
"assets/assets/Leeks.png": "9f625b666ec10e6338a002163af65afc",
"assets/assets/Lobak%2520(B).png": "54c38f497aaaeab1529c77248a4c0848",
"assets/assets/LOBAK%2520PUTIH.png": "70c173b9c8b9f566b7d8766ee8581989",
"assets/assets/Lobak.png": "54c38f497aaaeab1529c77248a4c0848",
"assets/assets/mail.png": "38fb62c49987bbb9f6108c4f1922dddf",
"assets/assets/Mint.png": "c500f25e0d8d9d214f7b3ec8bfeec4cf",
"assets/assets/Orange.png": "fa4a7e787659b960d5c42691e3018b91",
"assets/assets/Parsley.png": "1f5eccd7e2050a4a159b024106c27d19",
"assets/assets/Petai.png": "e77b96633515de4bab06c7cd18dccd3e",
"assets/assets/Pochoy.png": "9156e351daaa92920ac9336ca4afdc07",
"assets/assets/Potatoes.png": "4ff24e165ff792ec56cfaece7e85968d",
"assets/assets/Pumpkin.png": "4758d5a27f6d13fd58f2438793813e95",
"assets/assets/Red%2520Chilli%2520(A).png": "140bc0e3177e90f0314b330603967b11",
"assets/assets/Red%2520Chilli%2520(B).png": "140bc0e3177e90f0314b330603967b11",
"assets/assets/Red%2520Coral.png": "1b800de8bdf3d1a94a8a6b8e352f6870",
"assets/assets/Red%2520onion.png": "f803015018cb8dd307a55027df1c6a94",
"assets/assets/ROMAINE.png": "6ab343ed45e8493776df1e8e3c9b651e",
"assets/assets/ROUND%2520CABBAGE%2520CAMERON.png": "93820888e1028dcdf5bec419a37104e2",
"assets/assets/SALAD%2520KING.png": "26e362a1f0cee09d12c28437dba1c976",
"assets/assets/SALAT%2520BULAT%2520(ICEBERG).png": "99c66b6dd1f24f9dd223be9d1f9c9d87",
"assets/assets/SAWI%2520BUNGA.png": "652d555ff279a38ecc8f42abc4220c26",
"assets/assets/SAWI%2520JEPUN.png": "4acccba6a614cfa2ed9b78dee5f0742d",
"assets/assets/SAWI%2520PANJANG.png": "2c984d92999c5b83977575df5ff9e91a",
"assets/assets/SAWI%2520PUTIH.png": "c24969a08242781539f9f1b69626a6b3",
"assets/assets/Sawi%2520Susu.png": "4acccba6a614cfa2ed9b78dee5f0742d",
"assets/assets/spinner.json": "4f5708816d8d7093091ca834e78933d5",
"assets/assets/Strawberry%2520(A).png": "f5cdbe726c298e4453cce3bddf0b5acd",
"assets/assets/Strawberry%2520(B).png": "f5cdbe726c298e4453cce3bddf0b5acd",
"assets/assets/Sweet%2520Corn%2520-%2520A.png": "a26837377fdb277899903f9ce2a16bd1",
"assets/assets/Sweet%2520Corn%2520-%2520AA.png": "a26837377fdb277899903f9ce2a16bd1",
"assets/assets/Sweet%2520Corn%2520-%2520B.png": "a26837377fdb277899903f9ce2a16bd1",
"assets/assets/Sweet%2520Corn%2520-%2520C.png": "a26837377fdb277899903f9ce2a16bd1",
"assets/assets/Terung%2520Mini%2520(A).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Mini%2520(AA).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Mini%2520(B).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Mutiara%2520(A).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Mutiara%2520(AA).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/TERUNG%2520MUTIARA%2520(BRINJAL).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Panjang%2520(A).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Panjang%2520(AA).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/Terung%2520Panjang%2520(B).png": "0fac829b1c2f87176657696c92c4367f",
"assets/assets/TERUNG%2520PANJANG%2520(BRINJAL%2520LONG).png": "ddd656226f6868f1fdd4ceb10c97c924",
"assets/assets/Timun%2520Jepun%2520(A).png": "4e730816ba1d9547df318683d9eeb73c",
"assets/assets/Timun%2520Jepun%2520(B).png": "4e730816ba1d9547df318683d9eeb73c",
"assets/assets/TIMUN%2520JEPUN%2520(JAPANESE%2520CUCUMBER).png": "4e730816ba1d9547df318683d9eeb73c",
"assets/assets/Timun%2520Mini.png": "4e730816ba1d9547df318683d9eeb73c",
"assets/assets/Timun%2520Tua.png": "4e730816ba1d9547df318683d9eeb73c",
"assets/assets/TOMATO%2520(L).png": "65d432791ec36958fdd55a0f32e7977c",
"assets/assets/TOMATO%2520(M).png": "65d432791ec36958fdd55a0f32e7977c",
"assets/assets/Tomato%2520(S).png": "65d432791ec36958fdd55a0f32e7977c",
"assets/assets/TOMATO%2520(XL).png": "65d432791ec36958fdd55a0f32e7977c",
"assets/assets/YAUMAK%2520TAM.png": "c019fcc46aba4269321f08f48c826381",
"assets/assets/You%2520Mak%2520Tam.png": "c019fcc46aba4269321f08f48c826381",
"assets/assets/Zucchini%2520Green%2520(B).png": "5bd5736015ece96835a168dc61561337",
"assets/assets/Zucchini%2520Green.png": "5bd5736015ece96835a168dc61561337",
"assets/assets/Zucchini%2520Yellow%2520(B).png": "42f9f2f55b9f31797bd40983aeca25bf",
"assets/assets/Zucchini%2520Yellow.png": "42f9f2f55b9f31797bd40983aeca25bf",
"assets/assets/ZUCHINI%2520GREEN.png": "5bd5736015ece96835a168dc61561337",
"assets/assets/ZUCHINI%2520YELLOW.png": "42f9f2f55b9f31797bd40983aeca25bf",
"assets/FontManifest.json": "9a4889feb17d0ec47faf8fa66c6d7116",
"assets/fonts/MaterialIcons-Regular.otf": "de4229bac7f252179ed5b2c8af5afd07",
"assets/NOTICES": "9ce38ee436ee764a53a29e03c02a48f0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/weather_icons/lib/fonts/weathericons-regular-webfont.ttf": "b488ac89ad51a3869cb44f6c47f648a4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "fe8ac1fa957411ff31664cc267c40fba",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"flutter_bootstrap.js": "e7481f2f7efe184e1f6a9f8811214c5c",
"icons/android-icon-192x192.png": "e359155882c2c1756d9a1daf60a67234",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ccb960fc51e2ca7549a2c1338934a130",
"/": "ccb960fc51e2ca7549a2c1338934a130",
"main.dart.js": "b06eda7967451188d8e593e65bf2c374",
"manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"version.json": "ccfebb705ddb943d5663cd8d86286027"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
