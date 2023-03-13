Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E396B8001
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCMSLW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCMSLV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 14:11:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB076F74;
        Mon, 13 Mar 2023 11:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DA006145D;
        Mon, 13 Mar 2023 18:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E7EC433EF;
        Mon, 13 Mar 2023 18:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678731071;
        bh=YbU+0kUMJaZnSa7tMMVdbVJVj9WWTS5hkt3+89vm0Kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC/T8yVGkjmxwepJBMC7wvb6jeaWYU4HVs7AVGxILgi5qEdGJuPukZhu9fOdgt8o1
         wziGTCBcr+N8HkQakWMHRU1qVp4pJ6OAna6WF8Jy0Ar5p8ZgcRjZ0R1ru0fCDaXvTb
         Oi3PT1vQtVMX6VZQiCHyPvpZGHdxQlevMmwGV1tMP/Rf4nc2zro4w/qXLBBVwL9xKa
         khx/Q2xfAY9MiJBURVFQxO2h7X/n3/hVQ9wRP2JZ15k67nsunpqOeIL/9rexBLFNa8
         jPyYyy0meE04ko0fkslCb8ZyBY2wssY3YQdEDSZuAFLawG1TDtjXjMnXATTKaw7s+E
         kcB/RDMdJ3uJA==
Date:   Mon, 13 Mar 2023 11:11:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
Message-ID: <ZA9nPXNpBX0U5joC@sol.localdomain>
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-3-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313123310.13040-3-lhenriques@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 13, 2023 at 12:33:10PM +0000, Luís Henriques wrote:
> Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fixes
> a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'dir'
> has been evicted but the key is still available (for example, where there's
> a drop_caches).
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/file.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index dee3b445f415..5ad57cc4c13b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	ihold(dir);
>  	if (IS_ENCRYPTED(dir)) {
>  		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> -		if (!fscrypt_has_encryption_key(dir)) {
> -			spin_lock(&dentry->d_lock);
> -			dentry->d_flags |= DCACHE_NOKEY_NAME;
> -			spin_unlock(&dentry->d_lock);
> -		}
> +		err = fscrypt_prepare_atomic_open(dir, dentry);
> +		if (err)
> +			goto out_req;

Note that this patch does not apply to upstream or even to linux-next.

I'd be glad to take patch 1 through the fscrypt tree for 6.4.  But I'm wondering
what the current plans are for getting ceph's fscrypt support upstream?

- Eric
