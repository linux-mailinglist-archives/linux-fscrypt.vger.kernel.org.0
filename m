Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A686C1456
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 15:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCTOHQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 10:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjCTOHP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 10:07:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB591043A;
        Mon, 20 Mar 2023 07:07:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 50C4521AD5;
        Mon, 20 Mar 2023 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679321233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yo1ljBh40qQ38I7yL67r8GgZpmVGkTyCyvYo1Klawvg=;
        b=gR30Tzc5M9vXNhyEAWGCYnexklKeLqzCLnNVhaQReCr/JHWJZBZuM4DXKq4zlS4igtjSNv
        uBFSYBYrVNwXejkUBZg4Pq11nia2TqEKwDQsj5yfS5dW+i6GgYUqGNRpKDxtAjnTJn+zO+
        q73LV5ZvLVqsUe2XIdbpvqpVu4TtnUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679321233;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yo1ljBh40qQ38I7yL67r8GgZpmVGkTyCyvYo1Klawvg=;
        b=9KuzEM+WEuNP7Vy/Mkhq7JBgi8U4cSO7u10W/ngmR6YhNf8EZGHw2zx6f4EbIjrnqZ6cpG
        K3bdRR/bNEOPdFCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2A0213416;
        Mon, 20 Mar 2023 14:07:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YF0OKJBoGGSKFwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 20 Mar 2023 14:07:12 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 03fb36ae;
        Mon, 20 Mar 2023 14:07:10 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ceph: fscrypt: fix atomic open bug for encrypted
 directories
References: <20230316181413.26916-1-lhenriques@suse.de>
        <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com>
Date:   Mon, 20 Mar 2023 14:07:10 +0000
In-Reply-To: <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com> (Xiubo Li's
        message of "Mon, 20 Mar 2023 09:06:50 +0800")
Message-ID: <871qljv7n5.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 17/03/2023 02:14, Lu=C3=ADs Henriques wrote:
>> Hi!
>>
>> I started seeing fstest generic/123 failing in ceph fscrypt, when runnin=
g it
>> with 'test_dummy_encryption'.  This test is quite simple:
>>
>> 1. Creates a directory with write permissions for root only
>> 2. Writes into a file in that directory
>> 3. Uses 'su' to try to modify that file as a different user, and
>>     gets -EPERM
>>
>> All the test steps succeed, but the test fails to cleanup: 'rm -rf <dir>'
>> will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat() to re=
move
>> the file got a -ENOENT and then -ENOTEMPTY for the directory.
>>
>> This is because 'su' does a drop_caches ('su (874): drop_caches: 2' in
>> dmesg), and ceph's atomic open will do:
>>
>> 	if (IS_ENCRYPTED(dir)) {
>> 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> 		if (!fscrypt_has_encryption_key(dir)) {
>> 			spin_lock(&dentry->d_lock);
>> 			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> 			spin_unlock(&dentry->d_lock);
>> 		}
>> 	}
>>
>> Although 'dir' has the encryption key available, fscrypt_has_encryption_=
key()
>> will return 'false' because fscrypt info isn't yet set after the cache
>> cleanup.
>>
>> The first patch will add a new helper for the atomic_open that will force
>> the fscrypt info to be loaded into an inode that has been evicted recent=
ly
>> but for which the key is still available.
>>
>> The second patch switches ceph atomic_open to use the new fscrypt helper.
>>
>> Cheers,
>> --
>> Lu=C3=ADs
>>
>> Changes since v2:
>> - Make helper more generic and to be used both in lookup and atomic open
>>    operations
>> - Modify ceph_lookup (patch 0002) and ceph_atomic_open (patch 0003) to u=
se
>>    the new helper
>>
>> Changes since v1:
>> - Dropped IS_ENCRYPTED() from helper function because kerneldoc says
>>    already that it applies to encrypted directories and, most importantl=
y,
>>    because it would introduce a different behaviour for
>>    CONFIG_FS_ENCRYPTION and !CONFIG_FS_ENCRYPTION.
>> - Rephrased helper kerneldoc
>>
>> Changes since initial RFC (after Eric's review):
>> - Added kerneldoc comments to the new fscrypt helper
>> - Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
>> - Added IS_ENCRYPTED() check in helper
>> - DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() returns =
an
>>    error
>> - Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inline')
>
> This series looks good to me.
>
> And I have run the test locally and worked well.

Awesome, thanks a lot Xiubo.  I've been testing it locally as well and I
haven't observed any breakage either.

Cheers,
--=20
Lu=C3=ADs
