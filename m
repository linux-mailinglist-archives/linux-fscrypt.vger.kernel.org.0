Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E72374B353
	for <lists+linux-fscrypt@lfdr.de>; Fri,  7 Jul 2023 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjGGOyg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 7 Jul 2023 10:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjGGOyf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 7 Jul 2023 10:54:35 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7EE211D
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 07:53:48 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-76758b855edso151941685a.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 07:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688741627; x=1691333627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPovcDx0Jp7p0rxc31G4K4rf+RSfD3YoQjrCZo8Rivs=;
        b=Ia0yCXbDPsgNfjInB6NANIwD9QcfFsXTn93ZDdAx9tZAVjTw2qYghslkjF623WzVSC
         OpcFNRGFE/TA09GhEqIs0zqrE1dUgiKz4+pClTQ2Faijv0sBr+rnChZ0BTqyuNet0Nu5
         ugGAE7nvLL3ytXPYyuM05dVUjQrJYbC1piYwcchvR6mMyZOd/WW3WZ/xKLVhAe6IMXMX
         IGtdWPiGZ2qCVZxtmpfUUREYxgHdkRPTbkZEiCSf6q5VelOfFHpWD4ajrD/poqRXZG23
         r/A71Yd2nvbH9Ek0/eZFO7bqSGJgnF6N8oHZdCd+Byqos60Rg8rHWWqLe1w25GVoYeEK
         KJbw==
X-Gm-Message-State: ABy/qLZ3usmAMqWeA0g61FYZkTO4UNll7ooUdp1qo8ZKhRUJInUfDO+t
        q/G5SSIW1paiJVFAngedFanw
X-Google-Smtp-Source: APBJJlEcjwiB2P+G5P63povz9uFukN13UGlV0N1GEkdF3fsvn89XgwLKb03K3Qu7uI65bbZcCd9ADQ==
X-Received: by 2002:a05:620a:3944:b0:765:44c2:826d with SMTP id qs4-20020a05620a394400b0076544c2826dmr6230550qkn.27.1688741627214;
        Fri, 07 Jul 2023 07:53:47 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id m21-20020a05620a13b500b0076219ec1fbesm1900772qki.42.2023.07.07.07.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 07:53:46 -0700 (PDT)
Date:   Fri, 7 Jul 2023 10:53:45 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
        paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v10 11/17] dm-verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <ZKgm+ffQbdDTxrg9@redhat.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 28 2023 at  5:09P -0400,
Fan Wu <wufan@linux.microsoft.com> wrote:

> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> dm-verity provides a strong guarantee of a block device's integrity. As
> a generic way to check the integrity of a block device, it provides
> those integrity guarantees to its higher layers, including the filesystem
> level.
> 
> An LSM that control access to a resource on the system based on the
> available integrity claims can use this transitive property of
> dm-verity, by querying the underlying block_device of a particular
> file.
> 
> The digest and signature information need to be stored in the block
> device to fulfill the next requirement of authorization via LSM policy.
> This will enable the LSM to perform revocation of devices that are still
> mounted, prohibiting execution of files that are no longer authorized
> by the LSM in question.
> 
> This patch added two security hook calls in dm-verity to save the
> dm-verity roothash and the roothash signature to LSM blobs.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 26adcfea0302..54d46b2f2723 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1440,6 +1453,15 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->per_io_data_size = roundup(ti->per_io_data_size,
>  				       __alignof__(struct dm_verity_io));
>  
> +	root_digest.digest = v->root_digest;
> +	root_digest.digest_len = v->digest_size;
> +	root_digest.algo = v->alg_name;
> +
> +	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
> +				      sizeof(root_digest));
> +	if (r)
> +		goto bad;
> +
>  	verity_verify_sig_opts_cleanup(&verify_args);
>  
>  	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index 4836508ea50c..33165dd7470f 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -9,6 +9,9 @@
>  #include <linux/verification.h>
>  #include <keys/user-type.h>
>  #include <linux/module.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include "dm-core.h"

Why are you including dm-core.h here?

>  #include "dm-verity.h"
>  #include "dm-verity-verify-sig.h"
>  
> @@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
>   * verify_verify_roothash - Verify the root hash of the verity hash device
>   *			     using builtin trusted keys.
>   *
> + * @bdev: block_device representing the device-mapper created block device.
> + *	  Used by the security hook, to set information about the block_device.
>   * @root_hash: For verity, the roothash/data to be verified.
>   * @root_hash_len: Size of the roothash/data to be verified.
>   * @sig_data: The trusted signature that verifies the roothash/data.
>   * @sig_len: Size of the signature.
>   *
>   */
> -int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> -			    const void *sig_data, size_t sig_len)
> +int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
> +			    size_t root_hash_len, const void *sig_data,
> +			    size_t sig_len)
>  {
>  	int ret;
>  
> @@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
>  				NULL,
>  #endif
>  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> +	if (ret)
> +		return ret;
>  
> -	return ret;
> +	return security_bdev_setsecurity(bdev,
> +					 DM_VERITY_SIGNATURE_SEC_NAME,
> +					 sig_data, sig_len);
>  }
>  
>  void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)

Both of your calls to security_bdev_setsecurity() to set your blobs in
the bdev are suspect because you're doing so from the verity_ctr().
The mapped_device has 2 dm_table slots (active and inactive).  The
verity_ctr() becomes part of the inactive slot, there is an extra step
to bind the inactive table to the active table.

This leads to you changing the blobs in the global bdev _before_ the
table is actually active.  It is possible that the inactive table will
simply be removed and the DM verity device put back in service;
leaving your blob(s) in the bdev inconsistent.

This issue has parallels to how we need to defer changing the global
queue_limits associated with a request_queue until _after_ all table
loading is settled and then the update is done just before resuming
the DM device (mapped_device) -- see dm_table_set_restrictions().

Unfortunately, this feels like it may require a new hook in the
target_type struct (e.g. ->finalize())

Mike
