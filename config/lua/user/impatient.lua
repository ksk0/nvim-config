local status_ok, _ = pcall(require, "impatient")
if not status_ok then
  return
end

-- ====================================================================
-- collect diagnostic data of module loading times for analisys
-- we don't need that, so we will disable it
--
-- impatient.enable_profile()
