<script lang="ts">
  let name = "";
  let tel = "";

  const onRegister = () => {
    try {
      const result = fetch("/api/v1/users/new", {
        method: 'post',
        body: JSON.stringify({ name, tel })
      });

      window.alert("registered.");
    } catch(e) {
      window.alert("failed to register.");
    }
  }

  $: isButtonEnabled = name.trim() !== "" && tel.trim() !== "";
</script>

<div class="layout">
  <a href="/users">一覧</a>
  <label>
    名前:
    <input type="text" bind:value={name}>
  </label>
  <label>
    TEL:
    <input type="tel" bind:value={tel}>
  </label>
  <button on:click={onRegister} disabled={isButtonEnabled === false}>登録</button>
</div>

<style>
  .layout {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
</style>
