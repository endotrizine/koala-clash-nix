<div align="center">

[🇬🇧 English](README.md) | 🇷🇺 Русский

</div>

# Koala Clash NixOS Flake

Неофициальный NixOS flake для [Koala Clash](https://github.com/coolcoala/koala-clash).

Этот flake предоставляет:

- пакет Koala Clash для NixOS
- интеграцию через NixOS module
- поддержку TUN режима без запуска приложения от root

## Требования

- NixOS
- включённые flakes
- `x86_64-linux`

## Использование

### Добавление flake input

Добавьте Koala Clash в секцию `inputs` вашего NixOS flake:

```nix
inputs = {
  # другие inputs...

  koala-clash.url = "github:endotrizine/koala-clash-nix";
};
````

---

### Импорт NixOS module

Добавьте модуль Koala Clash в список `modules` вашего `nixosSystem`:

```nix
modules = [
  # другие модули...

  inputs.koala-clash.nixosModules.default
];
```

Пример:

```nix
nixosConfigurations = {
  hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ./configuration.nix

      inputs.koala-clash.nixosModules.default
    ];
  };
};
```

---

### Включение Koala Clash

Добавьте следующую опцию в вашу конфигурацию NixOS:

```nix
{
  programs.koala-clash.enable = true;
}
```

Пример:

```nix
{ config, pkgs, ... }:

{
  programs.koala-clash.enable = true;

  # другие опции NixOS...
}
```

---

### Пересборка системы

Примените конфигурацию:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Замените `hostname` на имя вашей NixOS конфигурации.

После пересборки Koala Clash можно запустить:

```bash
koala-clash
```

---

## TUN режим

Koala Clash требует доступ для создания TUN интерфейса.

Обычно для этого нужны повышенные привилегии:

```bash
sudo koala-clash
```

Этот flake автоматически настраивает необходимую Linux capability через NixOS wrapper.

Модуль предоставляет:

```
CAP_NET_ADMIN
```

что позволяет Koala Clash создавать TUN интерфейсы при запуске от обычного пользователя.

Проверить применение capability можно так:

```bash
getcap /run/wrappers/bin/koala-clash
```

Ожидаемый вывод:

```text
/run/wrappers/bin/koala-clash cap_net_admin=ep
```

---

## Обновление

Обновите flake input:

```bash
nix flake lock --update-input koala-clash
```

Затем пересоберите систему:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

---

## Использование пакета без NixOS module

Пакет также можно использовать напрямую:

```nix
environment.systemPackages = [
  inputs.koala-clash.packages.x86_64-linux.default
];
```

Обратите внимание: использование только пакета не настраивает права, необходимые для TUN режима.

Для полной функциональности используйте NixOS module.

---

## Решение проблем

### Ошибка доступа к TUN

Если Koala Clash выводит:

```text
Start TUN listening error: configure tun interface: operation not permitted
```

убедитесь, что NixOS module включён:

```nix
programs.koala-clash.enable = true;
```

и пересоберите систему:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

---

## Авторство

Koala Clash разрабатывается его оригинальными авторами.

Этот репозиторий предоставляет только упаковку и интеграцию для NixOS.
