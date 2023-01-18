Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAA67231B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Jan 2023 17:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjARQ1G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 Jan 2023 11:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjARQ0N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 Jan 2023 11:26:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABDB30E8F
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Jan 2023 08:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674059010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RGnao1lAV/nNnOtDlurEZBCllILrq8tNERQ9d8DE7Sc=;
        b=GnaGjq0nroyeYLMckEMWX/e/9x/phOiM0Pzo3n6k9ao5wxFt3FcMHauy6pMRc3mCZoQ9AZ
        9Hcrb0j8r7IH5Lep1Q7ag2XEYiSOAJgOrLwa3HgCPMB+kFfCkW7LXXAEGcwyVWTW+OFbF8
        TnhmoiKaToxX5mc8iWJksyVQF/tNUx4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-gAcB9E4SMHmEB6fMF-nFnw-1; Wed, 18 Jan 2023 11:23:26 -0500
X-MC-Unique: gAcB9E4SMHmEB6fMF-nFnw-1
Received: by mail-pg1-f198.google.com with SMTP id h185-20020a636cc2000000b004820a10a57bso15859562pgc.22
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Jan 2023 08:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGnao1lAV/nNnOtDlurEZBCllILrq8tNERQ9d8DE7Sc=;
        b=Prjff3LhEVZ29I2cNKht0bVPnfac0s8aIj2JvWc+Vj5+bn/hyGAeK2LBZ/03YoY+5W
         qQEdE0kDSuj5mM9ls/UTl1GOoqtZemH4IBXCD4n2IFXm8rlh8H+c3xZTbizp3/Yqwz9O
         GxAgQSBy4+CzMe2t2wzaOGeKGPRrqvj9rb4YxjLoGeVyyyl277RCaBncGSArUZZYeey1
         0zZqIKK4vz6ItPIlyKvBTgas8junhuDCobpNUe6pW4jFp33wanQWwArWqbzpNZ2eE599
         rSgKqesvg8/pb6YBWzq2w5okMXlxKK1DOK5x/vfDiJiPIN27Yzlim8EuSgE43jk7hn84
         MM9w==
X-Gm-Message-State: AFqh2krxUv/AbGGH7ZAq9p0HoEkh73iQNH7IppvniUzT1FTyXN7Bniv6
        xQeT1NslsMnLLLhN9UGsV4i+ZcCzj9woKAS+F8OMISikOPCcG8yq7EZgAEF/MLJIXLq6FC1WnM+
        e7MCoyMyZV0Y3klC/aKQQsIcm8w==
X-Received: by 2002:a05:6a21:3996:b0:b8:610f:cd43 with SMTP id ad22-20020a056a21399600b000b8610fcd43mr7226093pzc.35.1674059005802;
        Wed, 18 Jan 2023 08:23:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvWSr1cJAS4I7E+GTr5LaHjbixE6r0krRdym2rnNqIs7KfLy1Jk4pZsuq97h0RiA2WmXxHLBQ==
X-Received: by 2002:a05:6a21:3996:b0:b8:610f:cd43 with SMTP id ad22-20020a056a21399600b000b8610fcd43mr7226075pzc.35.1674059005476;
        Wed, 18 Jan 2023 08:23:25 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c4-20020a631c04000000b004774b5dc24dsm18998943pgc.12.2023.01.18.08.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:23:24 -0800 (PST)
Date:   Thu, 19 Jan 2023 00:23:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3] generic/692: generalize the test for non-4K Merkle
 tree block sizes
Message-ID: <20230118162310.bzhiubsbzu6bw3oa@zlang-mailbox>
References: <20230111205828.88310-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111205828.88310-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jan 11, 2023 at 12:58:28PM -0800, Eric Biggers wrote:
> From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Due to the assumption of the Merkle tree block size being 4K, the file
> size calculated for the second test case was taking way too long to hit
> EFBIG in case of larger block sizes like 64K.  Fix this by generalizing
> the calculation to any Merkle tree block size >= 1K.
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Co-developed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> v3: hashes_per_block, not hash_per_block
> v2: Cleaned up the original patch from Ojaswin:
>     - Explained the calculations as they are done.
>     - Considered 11 levels instead of 8, to account for 1K blocks
>       potentially needing up to 11 levels.
>     - Increased 'scale' for real number results, and don't use 'scale'
>       at all for integer number results.
>     - Improved a variable name.
>     - Updated commit message.

Hmm... There're two duplicated variables for "bc" --- BC and BC_PROG. I prefer
the later one. Anyway it doesn't affect this patch. I'll use another patch to
change all BC to BC_PROG, then remove BC.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
>  tests/generic/692 | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/generic/692 b/tests/generic/692
> index d6da734b..95f6ec04 100755
> --- a/tests/generic/692
> +++ b/tests/generic/692
> @@ -51,18 +51,31 @@ _fsv_enable $fsv_file |& _filter_scratch
>  #
>  # The Merkle tree is stored with the leaf node level (L0) last, but it is
>  # written first.  To get an interesting overflow, we need the maximum file size
> -# (MAX) to be in the middle of L0 -- ideally near the beginning of L0 so that we
> -# don't have to write many blocks before getting an error.
> -#
> -# With SHA-256 and 4K blocks, there are 128 hashes per block.  Thus, ignoring
> -# padding, L0 is 1/128 of the file size while the other levels in total are
> -# 1/128**2 + 1/128**3 + 1/128**4 + ... = 1/16256 of the file size.  So still
> -# ignoring padding, for L0 start exactly at MAX, the file size must be s such
> -# that s + s/16256 = MAX, i.e. s = MAX * (16256/16257).  Then to get a file size
> -# where MAX occurs *near* the start of L0 rather than *at* the start, we can
> -# just subtract an overestimate of the padding: 64K after the file contents,
> -# then 4K per level, where the consideration of 8 levels is sufficient.
> -sz=$(echo "scale=20; $max_sz * (16256/16257) - 65536 - 4096*8" | $BC -q | cut -d. -f1)
> +# ($max_sz) to be in the middle of L0 -- ideally near the beginning of L0 so
> +# that we don't have to write many blocks before getting an error.
> +
> +bs=$FSV_BLOCK_SIZE
> +hash_size=32   # SHA-256
> +hashes_per_block=$(echo "scale=30; $bs/$hash_size" | $BC -q)
> +
> +# Compute the proportion of the original file size that the non-leaf levels of
> +# the Merkle tree take up.  Ignoring padding, this is 1/($hashes_per_block^2) +
> +# 1/($hashes_per_block^3) + 1/($hashes_per_block^4) + ...  Compute it using the
> +# formula for the sum of a geometric series: \sum_{k=0}^{\infty} ar^k = a/(1-r).
> +a=$(echo "scale=30; 1/($hashes_per_block^2)" | $BC -q)
> +r=$(echo "scale=30; 1/$hashes_per_block" | $BC -q)
> +nonleaves_relative_size=$(echo "scale=30; $a/(1-$r)" | $BC -q)
> +
> +# Compute the original file size where the leaf level L0 starts at $max_sz.
> +# Padding is still ignored, so the real value is slightly smaller than this.
> +sz=$(echo "$max_sz/(1+$nonleaves_relative_size)" | $BC -q)
> +
> +# Finally, to get a file size where $max_sz occurs just after the start of L0
> +# rather than *at* the start of L0, subtract an overestimate of the padding: 64K
> +# after the file contents, then $bs per level for 11 levels.  11 levels is the
> +# most levels that can ever be needed, assuming the block size is at least 1K.
> +sz=$(echo "$sz - 65536 - $bs*11" | $BC -q)
> +
>  _fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
>  truncate -s $sz $fsv_file
>  _fsv_enable $fsv_file |& _filter_scratch
> -- 
> 2.39.0
> 

