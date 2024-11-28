package com.prangroup.mis93.tmbi.utils

import android.content.Context
import android.util.Log
import com.amazonaws.auth.BasicAWSCredentials
import com.amazonaws.mobileconnectors.s3.transferutility.TransferListener
import com.amazonaws.mobileconnectors.s3.transferutility.TransferObserver
import com.amazonaws.mobileconnectors.s3.transferutility.TransferState
import com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility
import com.amazonaws.services.s3.AmazonS3Client
import com.amazonaws.services.s3.model.CannedAccessControlList
import java.io.File

class AWSService(
    private val context: Context,
    private val onSuccess: (Boolean, String) -> Unit,
    private val onError: (Boolean, String) -> Unit,
) {
    private val accessKey = "NKHLZGVLLLAIV62USI5G"
    private val secretKey = "+hznHV41sb/5vlStEUczr0FZlS57hYWnNZh4HY6SSgk"
    private val endPoint = "https://sgp1.digitaloceanspaces.com/"
    private val bucketName = "spro"
    //private val appFolderName = "qpod"
    private val appFolderName = "track_all"

    fun uploadFile(file: File) {
        val credentials = BasicAWSCredentials(accessKey, secretKey)
        val observer: TransferObserver
        val s3 = AmazonS3Client(credentials)
        s3.endpoint = endPoint

        val transferUtility = TransferUtility(s3, context)
        val filePermission = CannedAccessControlList.PublicRead

        observer = transferUtility.upload(
            bucketName,  //bucket name, ex: spro
            "$appFolderName/${file.name}", file, filePermission
        )

        observer.setTransferListener(object : TransferListener {
            override fun onStateChanged(id: Int, state: TransferState) {
                if (TransferState.COMPLETED == observer.state) {
                    onSuccess(true, "Successfully saved")
                }
            }

            override fun onProgressChanged(id: Int, bytesCurrent: Long, bytesTotal: Long) {
                Log.i("uploadFile", "$bytesTotal : $bytesCurrent: ")
            }

            override fun onError(id: Int, ex: java.lang.Exception) {
                onError(false, "AWS_FILE_UPLOAD_ERROR:: ${ex.message}")
            }
        })
    }

}