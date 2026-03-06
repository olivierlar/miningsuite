"""Phase 0 skeletons: illustrative only (not production code)."""

from dataclasses import dataclass
from typing import Any, Protocol


@dataclass(frozen=True)
class Signal:
    data: Any
    srate: float | None = None
    metadata: dict[str, Any] | None = None


class Operator(Protocol):
    name: str

    def __call__(self, x: Signal, **kwargs: Any) -> Signal:
        ...


class SpectrumOperator:
    name = "spectrum"

    def __call__(self, x: Signal, **kwargs: Any) -> Signal:
        # TODO: replace with real implementation
        return x


class Plugin(Protocol):
    plugin_name: str
    version: str

    def register(self, registry: dict[str, Operator]) -> None:
        ...


class ExamplePlugin:
    plugin_name = "example_dsp"
    version = "0.1.0"

    def register(self, registry: dict[str, Operator]) -> None:
        registry[SpectrumOperator.name] = SpectrumOperator()
