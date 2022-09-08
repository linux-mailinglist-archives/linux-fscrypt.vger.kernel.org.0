Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8D5B1FAD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiIHNyA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 09:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiIHNxs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 09:53:48 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC5EF774D
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 06:53:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x3so561886qkn.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 06:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JWsIc2Qml+18h0yTurj1SY2PjzE9EMjlHe7m4hFECPM=;
        b=hD3URxSf2VR5seZber2wkQU5kjZHjbkJ3+RzttWljVYjSbM1HmXc6N9lx4UkMZ56L7
         CrUuM84qqzkCVtXyufde6Yq/+dvoLMXml1YN1qwqS1TfYxVQX54I3l9z9GkMYzUA2TZn
         P4bGpUrtE0mWihnSM2q+1r65mHEw82/gUr3XWkzOQbRvodhk+Jc/ylfhDdiKxbYFDg31
         O3eZ7c6R0cdmY4xNsjEQHGw3J45oBAKYnBpaqpc5YlJZ3TWFTzCYvsNvCIxmj2EuRAQl
         P2cPPvEwjotPA4bEv6cu7FNwfy/TA3y5jpngplrgq3O7PRSF+/Woiygm01vtqZEVryVg
         jpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JWsIc2Qml+18h0yTurj1SY2PjzE9EMjlHe7m4hFECPM=;
        b=XaPoNxUB1JSN4YzujYcyFuRqWsRFS2NAErRkBmEojg52N/Kq/0PGzmxyljBI7YlEg7
         UGc8mLv4j9dd7uI8c3zEHwbbrZDFPClCGEP4jhPjwcSvBvUMvKnti03qQSnjCM25PkQA
         HikTxRC3/Bxd2lKlokESQnYf6EV2XH80KDcDh1EIM3J5VnY+TGK/4qLFKnekHioKE6HL
         NTxUePonv8vHQHmCuJt9Fe24hV/q9ZzPw85+KoUepdhTZbiZGFN2Jf9BBSSMjTJxrEav
         2RZdO25V6jbfVv7ZR0W/3ET5PRR0MoqXq7K6apxk8r7WYMyQ/anAZSl/6RElZJ08EEq2
         qt3w==
X-Gm-Message-State: ACgBeo2DpfAIbrd/yqLj06aY/P7wqhaN1i+URZsEBWbBOxd8qml3zAvv
        xVexIL1YLiqZtx84ajw4eoJoeQ==
X-Google-Smtp-Source: AA6agR5TVJmlLCbOemA8UqrIrAdm0bxCQBEVcfl1Prw803myua8N15q+D2J71h/X7nUsepf5fsu/HA==
X-Received: by 2002:a05:620a:1a09:b0:6c0:900d:1609 with SMTP id bk9-20020a05620a1a0900b006c0900d1609mr6525143qkb.42.1662645224605;
        Thu, 08 Sep 2022 06:53:44 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id f1-20020a05620a408100b006bbd0ae9c05sm18319796qko.130.2022.09.08.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:53:43 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:53:37 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 03/20] fscrypt: add fscrypt_have_same_policy() to
 check inode compatibility
Message-ID: <Yxnz4dayQynNgqCE@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <59fe9cb2916e7bad3bc57abc211a35f0a85990bc.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59fe9cb2916e7bad3bc57abc211a35f0a85990bc.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:18PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Btrfs will need to check whether inode policies are identical for
> various purposes: if two inodes want to share an extent, they must have
> the same policy, including key identifier; symlinks must not span the
> encrypted/unencrypted border; and certain encryption policies will allow
> btrfs to store one fscrypt_context for multiple objects. Therefore, add
> a function which allows checking the encryption policies of two inodes
> to ensure they are identical.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/policy.c      | 26 ++++++++++++++++++++++++++
>  include/linux/fscrypt.h |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 80b8ca0f340b..ed8b7b6531e5 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -415,6 +415,32 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
>  	return fscrypt_policy_from_context(policy, &ctx, ret);
>  }
>  
> +/**
> + * fscrypt_have_same_policy() - check whether two inodes have the same policy
> + * @inode1: the first inode
> + * @inode2: the second inode
> + *
> + * Return: %true if equal, else %false
> + */
> +int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2)
> +{
> +	union fscrypt_policy policy1, policy2;
> +	int err;
> +
> +	if (!IS_ENCRYPTED(inode1) && !IS_ENCRYPTED(inode2))
> +		return true;
> +	else if (!IS_ENCRYPTED(inode1) || !IS_ENCRYPTED(inode2))
> +		return false;
> +	err = fscrypt_get_policy(inode1, &policy1);
> +	if (err)
> +		return err;
> +	err = fscrypt_get_policy(inode2, &policy2);
> +	if (err)
> +		return err;

These things can return random errors, so you're mixing bool with errnos, and
then you're using this function as if it only returns bools.  I'm not sure what
the best thing to do is here for consistency, maybe return 0 for no match, 1 for
match, and then err and handle it that way.  At the very least the callers need
to be updated to handle the errors.  But I really don't like the mixing of bool
returns with ERRNO returns.  An alternative would be to have a helper do the
getting of the policies which will give you the errno's appropriately, and then
do the call to fscrypt_policies_equal with the policies you grab.  Thanks,

Josef
