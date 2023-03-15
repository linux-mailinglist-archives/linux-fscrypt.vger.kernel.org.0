Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9392B6BAEF0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjCOLMl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 07:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjCOLMX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 07:12:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953E58F50B;
        Wed, 15 Mar 2023 04:10:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 77F602199E;
        Wed, 15 Mar 2023 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678878504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaOO2L3V5hIswZP380eKYyW5qie3utQkj7K3xV+mclw=;
        b=FesTWKG/ExAxAACAknaPChpQr4DNtt+L3mNZPSgREwqkuJWB2rxIpuBYNacuHsoRzShd1N
        2r7/k871t2aR9q0MuFSw93BXizmskFMo+duzRscVE9FDGTroh+4bTL4lnfxPzm8F3RNb/P
        EHAX5istRV83i4MPyCFfNSzmqm1e4GI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678878504;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaOO2L3V5hIswZP380eKYyW5qie3utQkj7K3xV+mclw=;
        b=58f31VIgyWiNRkQcrdo+Aj3cJrdUxG1Kr8H80WCCvoARBTS2E9F2REeHcwTZQoXun2wuxY
        nFwXgdwooWS8ciCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF59613A00;
        Wed, 15 Mar 2023 11:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tzx4LyenEWQsXgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 15 Mar 2023 11:08:23 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id ae04abbe;
        Wed, 15 Mar 2023 11:08:23 +0000 (UTC)
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
        <ZA9mwPUg7H/fq0L8@sol.localdomain> <87zg8ftz9s.fsf@suse.de>
        <ZBC1P4Gn6eAKD61+@sol.localdomain>
Date:   Wed, 15 Mar 2023 11:08:23 +0000
In-Reply-To: <ZBC1P4Gn6eAKD61+@sol.localdomain> (Eric Biggers's message of
        "Tue, 14 Mar 2023 10:56:15 -0700")
Message-ID: <87pm9atgpk.fsf@suse.de>
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

> On Tue, Mar 14, 2023 at 10:15:11AM +0000, Lu=C3=ADs Henriques wrote:
>> Eric Biggers <ebiggers@kernel.org> writes:
>>=20
>> > On Mon, Mar 13, 2023 at 12:33:09PM +0000, Lu=C3=ADs Henriques wrote:
>> >> + * The regular open path will use fscrypt_file_open for that, but in=
 the
>> >> + * atomic open a different approach is required.
>> >
>> > This should actually be fscrypt_prepare_lookup, not fscrypt_file_open,=
 right?
>>=20
>> Ups, I missed this comment.
>>=20
>> I was comparing the regular open() with the atomic_open() paths.  I think
>> I really mean fscrypt_file_open() because that's where the encryption in=
fo
>> is (or may be) set by calling fscrypt_require_key().  atomic_open needs
>> something similar, but combined with a lookup.
>>=20
>> Maybe I can rephrase it to:
>>=20
>>   The reason for getting the encryption info before checking if the
>>   directory has the encryption key is because the key may be available b=
ut
>>   the encryption info isn't yet set (maybe due to a drop_caches).  The
>>   regular open path will call fscrypt_file_open which uses function
>>   fscrypt_require_key for setting the encryption info if needed.  The
>>   atomic open needs to do something similar.
>>=20
>
> No, regular open is two parts: ->lookup and ->open.  fscrypt_prepare_look=
up()
> sets up the directory's key, whereas fscrypt_file_open() sets up the file=
's key.
>
> Your proposed fscrypt_prepare_atomic_open() sets up the directory's key. =
 So it
> is really fscrypt_prepare_lookup() that is its equivalent.

Oh, I see what you mean now, and you're obviously correct.  Thanks for the
detailed explanation.

> However, that raises the question of why doesn't ceph just use
> fscrypt_prepare_lookup()?  It seems the answer is that ceph wants to hand=
le the
> filenames encryption and no-key name encoding itself.  And for that reaso=
n, its
> ->lookup() does the following and does *not* use fscrypt_prepare_lookup():
>
> 	if (IS_ENCRYPTED(dir)) {
> 		err =3D ceph_fscrypt_prepare_readdir(dir);
> 		if (err < 0)
> 			return ERR_PTR(err);
> 		if (!fscrypt_has_encryption_key(dir)) {
> 			spin_lock(&dentry->d_lock);
> 			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> 			spin_unlock(&dentry->d_lock);
> 		}
> 	}

Ugh, I tend to forget all the details behind these decisions.  If I
remember correctly, we had to work around the fact that the cephfs client
handle directory data in a cumbersome way.  We may not have the full data
for a readdir, for example, and that has to be handled by a lookup.

> So, actually I think this patch doesn't make sense.  If ceph is doing the=
 above
> in its ->lookup() anyway, then it just should do the exact same thing in =
its
> ->atomic_open() too.

In fact, my initial fix for the cephfs bug was doing just that.  It was a
single patch to ceph_atomic_open() that would simply do:

	if (IS_ENCRYPTED(dir)) {
		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
		err =3D __fscrypt_prepare_readdir(dir);
		if (!err && !fscrypt_has_encryption_key(dir)) {
			spin_lock(&dentry->d_lock);
			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
			spin_unlock(&dentry->d_lock);
		}
	}

What made me want to create a new helper was that I simply needed to call
fscrypt_get_encryption_info() to force the encryption info to be set in
the parent directory.  But this function was only accessible through
__fscrypt_prepare_readdir(), which isn't really a great function name for
what I need here.

Since __fscrypt_prepare_readdir() doesn't seem to be used anywhere else,
maybe it could be removed and fscrypt_get_encryption_info() be exported
instead?

> If you want to add a new fscrypt_* helper function which *just* sets up t=
he
> given directory's key and sets the NOKEY_NAME flag on the given dentry
> accordingly, that could make sense.  However, it should be called from *b=
oth*
> ->lookup() and ->atomic_open(), not just ->atomic_open().
>
> It's also worth mentioning that setting up the filename separately from t=
he
> NOKEY_NAME flag makes ceph have the same race condition that I had fixed =
for the
> other filesystems in commit b01531db6cec ("fscrypt: fix race where ->look=
up()
> marks plaintext dentry as ciphertext").  It's not a huge deal, but it can=
 cause
> some odd behavior, so it's worth thinking about whether it can be solved.

Hmm... OK, looks like we'll need to have a look into this.  Thanks for the
heads-up.

Cheers,
--=20
Lu=C3=ADs
