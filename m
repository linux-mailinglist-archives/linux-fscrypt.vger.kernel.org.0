Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD66BBB91
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 18:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjCOR7W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 13:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCOR7V (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 13:59:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4A10E1;
        Wed, 15 Mar 2023 10:59:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 01B2F1FD89;
        Wed, 15 Mar 2023 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678903157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLT3eYZtJrObhgAAOazre+6sHMMLZ43CUH/KuRHTFyg=;
        b=tnV1wnzbHy+vuLgW2A6uUZlZTEz9KHshNl60JYUkBG6hlAUgHRgOMWDHw8hBaJkqGU88uF
        EGpyRyPsxeaN6n9IRC+Uzv89sWtSgXEpem7j98O1iawD/RDMKtLBGYXzvODr2mF+IkaIRY
        rjuch+rG5gJqq1F8u5oY6qZsYsic77A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678903157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLT3eYZtJrObhgAAOazre+6sHMMLZ43CUH/KuRHTFyg=;
        b=mlmuOq0PZaC1B+YF/8GREFDB0Jqby4F62paetmapGoys81iOS8PPgQCK4a/mZAxWeqT52N
        xwnnnmkLfwGptrAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66A4613A2F;
        Wed, 15 Mar 2023 17:59:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8W+qFXQHEmS6NwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 15 Mar 2023 17:59:16 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 0069d46e;
        Wed, 15 Mar 2023 17:59:13 +0000 (UTC)
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
        <ZBC1P4Gn6eAKD61+@sol.localdomain> <87pm9atgpk.fsf@suse.de>
        <20230315171249.GA975@sol.localdomain>
Date:   Wed, 15 Mar 2023 17:59:13 +0000
In-Reply-To: <20230315171249.GA975@sol.localdomain> (Eric Biggers's message of
        "Wed, 15 Mar 2023 10:12:49 -0700")
Message-ID: <873565sxou.fsf@suse.de>
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

> On Wed, Mar 15, 2023 at 11:08:23AM +0000, Lu=C3=ADs Henriques wrote:
>> > So, actually I think this patch doesn't make sense.  If ceph is doing =
the above
>> > in its ->lookup() anyway, then it just should do the exact same thing =
in its
>> > ->atomic_open() too.
>>=20
>> In fact, my initial fix for the cephfs bug was doing just that.  It was a
>> single patch to ceph_atomic_open() that would simply do:
>>=20
>> 	if (IS_ENCRYPTED(dir)) {
>> 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> 		err =3D __fscrypt_prepare_readdir(dir);
>> 		if (!err && !fscrypt_has_encryption_key(dir)) {
>> 			spin_lock(&dentry->d_lock);
>> 			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> 			spin_unlock(&dentry->d_lock);
>> 		}
>> 	}
>>=20
>> What made me want to create a new helper was that I simply needed to call
>> fscrypt_get_encryption_info() to force the encryption info to be set in
>> the parent directory.  But this function was only accessible through
>> __fscrypt_prepare_readdir(), which isn't really a great function name for
>> what I need here.
>>=20
>> Since __fscrypt_prepare_readdir() doesn't seem to be used anywhere else,
>> maybe it could be removed and fscrypt_get_encryption_info() be exported
>> instead?
>
> Well, fscrypt_get_encryption_info() *used* to be exported, but it was har=
d to
> keep track of its use cases (some of which were not actually necessary), =
which
> is why it eventually got replaced with use-case oriented helper functions.
>
> Maybe just use fscrypt_prepare_lookup_partial() for the name of your new =
helper
> function (instead of fscrypt_prepare_atomic_open())?

OK, thanks for the name suggestion (naming is *indeed* hard).  I'll go try
to get a new helper that can be used in both open_atomic and lookup.
That'll require a bit more of testing so that I don't end up breaking
something else.

Cheers,
--=20
Lu=C3=ADs
