Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C616B8EB3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 10:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCNJ1r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 05:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCNJ1q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 05:27:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B07499C3C;
        Tue, 14 Mar 2023 02:27:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B49C821D35;
        Tue, 14 Mar 2023 09:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678786063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90V7Jm+NR0G7HuZEurEP4+aqZskrhU8Z7L5jRsbGqQU=;
        b=lVSGYpcxT6hSnqoyIHlydXh87Ypl0E4bQD6Wxv+f2eHl7A926/vArSDuSq0Eo7aXf4Fcn1
        6uv3qA+aniJBkHkf2l9Ti1yPKeBpML9ufsAs6Km2MLPspXW26fwA1ztwZTHjY4OGekbuov
        5AoZ1V03+Js04kc0//zLHy+KfRaRL38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678786063;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90V7Jm+NR0G7HuZEurEP4+aqZskrhU8Z7L5jRsbGqQU=;
        b=6PSvqnZLwlYmjEPnDQDDxtjFEQJcjnUOqArS5Xbzih85hqw1uP3bqTvS6MOQXU5r3quKfe
        IGvCsYnG+6sp1PBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A91F13A1B;
        Tue, 14 Mar 2023 09:27:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YZo3Bw8+EGT5aAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 09:27:43 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id e50d13ca;
        Tue, 14 Mar 2023 09:27:42 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
References: <20230313123310.13040-1-lhenriques@suse.de>
        <20230313123310.13040-3-lhenriques@suse.de>
        <ZA9nPXNpBX0U5joC@sol.localdomain> <87cz5cv6h2.fsf@suse.de>
        <8aa61954-b6c4-d9b5-bb81-c03ca3631e3b@redhat.com>
Date:   Tue, 14 Mar 2023 09:27:42 +0000
In-Reply-To: <8aa61954-b6c4-d9b5-bb81-c03ca3631e3b@redhat.com> (Xiubo Li's
        message of "Tue, 14 Mar 2023 08:38:49 +0800")
Message-ID: <874jqnvg1d.fsf@suse.de>
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

Xiubo Li <xiubli@redhat.com> writes:

> On 14/03/2023 02:42, Lu=C3=ADs Henriques wrote:
>> Eric Biggers <ebiggers@kernel.org> writes:
>>
>>> On Mon, Mar 13, 2023 at 12:33:10PM +0000, Lu=C3=ADs Henriques wrote:
>>>> Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fi=
xes
>>>> a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'd=
ir'
>>>> has been evicted but the key is still available (for example, where th=
ere's
>>>> a drop_caches).
>>>>
>>>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>>> ---
>>>>   fs/ceph/file.c | 8 +++-----
>>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index dee3b445f415..5ad57cc4c13b 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct de=
ntry *dentry,
>>>>   	ihold(dir);
>>>>   	if (IS_ENCRYPTED(dir)) {
>>>>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>>> -		if (!fscrypt_has_encryption_key(dir)) {
>>>> -			spin_lock(&dentry->d_lock);
>>>> -			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>>>> -			spin_unlock(&dentry->d_lock);
>>>> -		}
>>>> +		err =3D fscrypt_prepare_atomic_open(dir, dentry);
>>>> +		if (err)
>>>> +			goto out_req;
>>> Note that this patch does not apply to upstream or even to linux-next.
>> True, I should have mentioned that in the cover-letter.  This patch shou=
ld
>> be applied against the 'testing' branch in https://github.com/ceph/ceph-=
client,
>> which is where the ceph fscrypt currently lives.
>>
>>> I'd be glad to take patch 1 through the fscrypt tree for 6.4.  But I'm =
wondering
>>> what the current plans are for getting ceph's fscrypt support upstream?
>> As far as I know, the current plan is to try to merge the ceph code duri=
ng
>> the next merge window for 6.4 (but Xiubo and Ilya may correct me if I'm
>> wrong).  Also, regarding who picks which patch, I'm fine with you picking
>> the first one.  But I'll let the ceph maintainers say what they think,
>> because it may be easier for them to keep both patches together due to t=
he
>> testing infrastructure being used.
>>
>> Anyway, I'll send out a new rev tomorrow taking your comments into
>> account.  Thanks, Eric!
>
> Eric, Luis,
>
> It will be fine if Eric could merge patch 1 into the fscrypt tree. Then I=
 will
> merge the patch 1 into the ceph-client's testing by tagging as [DO NOT ME=
RGE] to
> run our tests.

Awesome, so Eric can pick the first patch.  Thanks.

Cheers,
--=20
Lu=C3=ADs

> And locally we are still running the test, and there have several fixes f=
ollowed
> and need more time to review.
>
> Thanks
>
> - Xiubo
>
>> Cheers,
>
> --=20
> Best Regards,
>
> Xiubo Li (=E6=9D=8E=E7=A7=80=E6=B3=A2)
>
> Email: xiubli@redhat.com/xiubli@ibm.com
> Slack: @Xiubo Li
>

