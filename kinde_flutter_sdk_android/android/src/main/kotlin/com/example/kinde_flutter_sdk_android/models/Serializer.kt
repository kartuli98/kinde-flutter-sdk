import au.kinde.sdk.infrastructure.ByteArrayAdapter
import au.kinde.sdk.infrastructure.OffsetDateTimeAdapter
import com.example.kinde_flutter_sdk_android.infrastructure.LocalDateTimeAdapter
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.OffsetDateTime

object Serializer {
  @JvmStatic
  val gsonBuilder: GsonBuilder = GsonBuilder()
    .registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeAdapter())
    .registerTypeAdapter(LocalDateTime::class.java, LocalDateTimeAdapter())
    .registerTypeAdapter(LocalDate::class.java, LocalDateAdapter())
    .registerTypeAdapter(ByteArray::class.java, ByteArrayAdapter())

  @JvmStatic
  val gson: Gson by lazy {
    gsonBuilder.create()
  }
}
