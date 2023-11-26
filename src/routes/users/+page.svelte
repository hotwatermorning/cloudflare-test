<script lang="ts">
  import { onMount } from "svelte";

  type User = {
    id: number;
    name: string;
    tel: string;
  }

  let users: User[] = [];

  onMount(async () => {
    try {
      const res = await fetch("/api/v1/users");
      users = await res.json();
    } catch(e) {
      window.alert("failed to get users.");
    }
  });
</script>

<div class="layout">
  <a href="/users/new">新規登録</a>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Tel</th>
      </tr>
    </thead>
    <tbody>
      {#each users as u}
        <tr>
          <td>{u.id}</td>
          <td>{u.name}</td>
          <td>{u.tel}</td>
        </tr>
      {/each}
    </tbody>
  </table>
</div>

<style>
</style>
