return {
	---------
	-- Vue --
	---------

	{
		prefix = "___vueSetup",
		body = [[<script setup lang="ts">
//
</script>

<template>
  <div>
    component
  </div>
</template>

<style module lang="scss">
//
</style>]],
	},

	{
		prefix = "___vueOptions",
		body = [[<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
//
})
</script>

<template>
  <div>
    component
  </div>
</template>

<style module lang="scss">
//
</style>]],
	},

	{
		prefix = "___vueOptionsOld",
		body = [[<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
//
})
</script>

<template>
  <div>
    component
  </div>
</template>

<style module lang="scss">
//
</style>]],
	},
}
