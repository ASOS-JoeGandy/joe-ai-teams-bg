var myHeaders = new Headers();
myHeaders.append("Content-Type", "application/json");
const fs = require("fs");
const contents = fs.readFileSync("./source.jpg", { encoding: "base64" });

let prompts = [];

process.argv.forEach(function (_prompt, index, array) {
  if (index < 2) return;
  prompts.push(_prompt);
});

console.log("-------- Processing prompts ---------");
prompts.forEach((_prompt) => console.log(` - ${_prompt}`));
console.log("Warning each one can take upwards of a minute");

prompts.forEach((_prompt, index) => {
  const safePromptName = _prompt.replace(/[^a-zA-Z0-9]/g, '');

  var raw = JSON.stringify({
    alwayson_scripts: {
      Comments: { args: [] },
      "Extra options": { args: [] },
      Hypertile: { args: [] },
      Refiner: {
        args: [true, "ghostmix_v20Bakedvae.safetensors [e3edb8a26f]", 0.47],
      },
      Sampler: { args: [20, "DPM++ 2M", "Automatic"] },
      Seed: { args: [-1, false, -1, 0, 0, 0] },
      "Soft Inpainting": { args: [false, 1, 0.5, 4, 0, 0.5, 2] },
    },
    batch_size: 1,
    cfg_scale: 28,
    comments: {},
    denoising_strength: 0.52,
    disable_extra_networks: false,
    do_not_save_grid: false,
    do_not_save_samples: false,
    height: 512,
    image_cfg_scale: 1.5,
    init_images: [contents],
    initial_noise_multiplier: 1.0,
    inpaint_full_res: 0,
    inpaint_full_res_padding: 32,
    inpainting_fill: 1,
    inpainting_mask_invert: 0,
    mask_blur: 4,
    mask_blur_x: 4,
    mask_blur_y: 4,
    mask_round: true,
    n_iter: 1,
    negative_prompt: "people person",
    override_settings: {},
    override_settings_restore_afterwards: true,
    prompt: _prompt,
    resize_mode: 0,
    restore_faces: false,
    s_churn: 0.0,
    s_min_uncond: 0.0,
    s_noise: 1.0,
    s_tmax: null,
    s_tmin: 0.0,
    sampler_name: "DPM++ 2M",
    scheduler: "Automatic",
    script_args: [],
    script_name: null,
    seed: -1,
    seed_enable_extras: true,
    seed_resize_from_h: -1,
    seed_resize_from_w: -1,
    steps: 35,
    styles: [],
    subseed: -1,
    subseed_strength: 0,
    tiling: false,
    width: 904,
  });

  var requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow",
  };

  fetch("http://127.0.0.1:7860/sdapi/v1/img2img", requestOptions)
    .then((response) => response.text())
    .then((result) => {
      const resultObject = JSON.parse(result);
      require("fs").writeFile(
        `./ai-images/${safePromptName}.png`,
        resultObject.images[0],
        "base64",
        function (err) {
          console.log(err);
        }
      );
      console.log(`ai-images/${safePromptName}.png has been created ${index+1}/${prompts.length}`);
    })
    .catch((error) => error && console.log("error", error));
});
