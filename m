Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FB16B8F82
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 11:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjCNKQa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 06:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjCNKQX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 06:16:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637A21910A;
        Tue, 14 Mar 2023 03:15:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6ED071F893;
        Tue, 14 Mar 2023 10:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678788912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJ2tWgbaj1kPFs+SKfFXIBRjqWuylcoIvykgClDHkKQ=;
        b=f5Wl30HJz9caS+i7Rjnuo7Hd9cZ1zlkdrJ7zDkJpYyiME1trwCYWd9JYuqpH1v2nJR12Ae
        QJSz0UxXGR16Rn4CDNS7W3WEtF8EmHgifRZcfVReWYMu46Jk8IOlkjkGRmxgOsc459ezIX
        qPipelgnOp5K2YFBkjRZ6inTpUjTDZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678788912;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJ2tWgbaj1kPFs+SKfFXIBRjqWuylcoIvykgClDHkKQ=;
        b=CvUAsxSmG5Q5PNoxXxAzchHHgNQuijdyx5Sbm61RUDsaEfIFl8Rml++1HJeZ+x66FFrEP9
        dbwsObbSJdBUBbCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D5F5F13A26;
        Tue, 14 Mar 2023 10:15:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OP8GMS9JEGRDBwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 10:15:11 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 48a9b60e;
        Tue, 14 Mar 2023 10:15:11 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
References: <20230313123310.13040-1-lhenriques@suse.de>
        <20230313123310.13040-2-lhenriques@suse.de>
        <ZA9mwPUg7H/fq0L8@sol.localdomain>
Date:   Tue, 14 Mar 2023 10:15:11 +0000
In-Reply-To: <ZA9mwPUg7H/fq0L8@sol.localdomain> (Eric Biggers's message of
        "Mon, 13 Mar 2023 11:09:04 -0700")
Message-ID: <87zg8ftz9s.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Mon, Mar 13, 2023 at 12:33:09PM +0000, Lu=C3=ADs Henriques wrote:
>> + * The regular open path will use fscrypt_file_open for that, but in the
>> + * atomic open a different approach is required.
>
> This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, ri=
ght?

Ups, I missed this comment.

I was comparing the regular open() with the atomic_open() paths.  I think
I really mean fscrypt_file_open() because that's where the encryption info
is (or may be) set by calling fscrypt_require_key().  atomic_open needs
something similar, but combined with a lookup.

Maybe I can rephrase it to:

  The reason for getting the encryption info before checking if the
  directory has the encryption key is because the key may be available but
  the encryption info isn't yet set (maybe due to a drop_caches).  The
  regular open path will call fscrypt_file_open which uses function
  fscrypt_require_key for setting the encryption info if needed.  The
  atomic open needs to do something similar.

Cheers,
--=20
Lu=C3=ADs

>> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentr=
y)
>> +{
>> +	int err;
>> +
>> +	if (!IS_ENCRYPTED(dir))
>> +		return 0;
>> +
>> +	err =3D fscrypt_get_encryption_info(dir, true);
>> +	if (!err && !fscrypt_has_encryption_key(dir)) {
>> +		spin_lock(&dentry->d_lock);
>> +		dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> +		spin_unlock(&dentry->d_lock);
>> +	}
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
> [...]
>> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
>> +					      struct dentry *dentry)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>
> This has different behavior on unencrypted directories depending on wheth=
er
> CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.
>
> In patch 2, the caller you are introducing has already checked IS_ENCRYPT=
ED().
>
> Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it is=
 for
> *encrypted* directories.
>
> So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYPTION
> version of fscrypt_prepare_atomic_open().
>
> - Eric

