;; File Storage Smart Contract
;; Manages file storage entries on the Stacks blockchain

(define-data-var next-file-id uint u1)

(define-map files 
    { id: uint } 
    { 
        owner: principal, 
        location: (string-ascii 256), 
        expiry: uint 
    })

(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_FILE_NOT_FOUND (err u101))
(define-constant ERR_FILE_ALREADY_EXISTS (err u102))
(define-constant ERR_EXPIRED (err u103))

;; Add a new file entry
(define-public (add-file (location (string-ascii 256)) (expiry uint))
    (begin
        (let ((file-id (var-get next-file-id)))
            (if (is-some (map-get? files { id: file-id }))
                ERR_FILE_ALREADY_EXISTS
                (if (> expiry stacks-block-height)
                    (if (is-some (as-max-len? location u256))
                        (begin
                            (map-set files { id: file-id } { owner: tx-sender, location: location, expiry: expiry })
                            (var-set next-file-id (+ file-id u1))
                            (ok file-id)
                        )
                        ERR_NOT_AUTHORIZED
                    )
                    ERR_EXPIRED
                )
            )
        )
    )
)

;; Fetch file details by ID
(define-public (get-file (file-id uint))
    (match (map-get? files { id: file-id })
        file-data
        (if (<= (get expiry file-data) tenure-height)
            ERR_EXPIRED
            (ok file-data))
        ERR_FILE_NOT_FOUND
    )
)

;; Update the file location or expiry (Only file owner can do this)
(define-public (update-file (file-id uint) (new-location (string-ascii 256)) (new-expiry uint))
    (let ((current-id (var-get next-file-id)))
        (if (>= file-id current-id)
            ERR_FILE_NOT_FOUND
            (match (map-get? files { id: file-id })
                file-data
                (if (is-eq (get owner file-data) tx-sender)
                    (if (> new-expiry stacks-block-height)
                        (if (is-some (as-max-len? new-location u256))
                            (begin
                                (map-set files 
                                    { id: file-id } 
                                    { owner: tx-sender, location: new-location, expiry: new-expiry }
                                )
                                (ok true)
                            )
                            ERR_NOT_AUTHORIZED
                        )
                        ERR_EXPIRED
                    )
                    ERR_NOT_AUTHORIZED
                )
                ERR_FILE_NOT_FOUND
            )
        )
    )
)

;; Delete file entry (Only file owner can do this)
(define-public (delete-file (file-id uint))
    (let ((current-id (var-get next-file-id)))
        (if (>= file-id current-id)
            ERR_FILE_NOT_FOUND
            (match (map-get? files { id: file-id })
                file-data
                (if (is-eq (get owner file-data) tx-sender)
                    (begin
                        (map-delete files { id: file-id })
                        (ok true)
                    )
                    ERR_NOT_AUTHORIZED
                )
                ERR_FILE_NOT_FOUND
            )
        )
    )
)