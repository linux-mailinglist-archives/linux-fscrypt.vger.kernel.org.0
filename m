Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608C54AD13C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 06:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbiBHFuq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Feb 2022 00:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbiBHFuo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Feb 2022 00:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481F0C0401DC;
        Mon,  7 Feb 2022 21:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5CDF6155A;
        Tue,  8 Feb 2022 05:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C42C004E1;
        Tue,  8 Feb 2022 05:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644299442;
        bh=TicygsgleVlUaz7G3ja6PR1QdTGvF1cHrJxoSj4FJlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uICo0s+TSSpGtGQyJHoeSya09jVrA++MU7y4R+gJsY763e29KMYaB1xE5y6po2+SS
         I2FnLwwzk/45wqq6R8OVEnY9Sn7z0xDTkLK6bTSe/gokWnjs3deiqsK519476J8h6A
         5SnJNirURFvKOuGA/9z4zmGImKNPdCkrFSHievoiLIEF33glznf0Vc3yVVfSM+055W
         tuVVz7XJfiWKND6nhUbpX4rMaQQePka7ejPc1ratwnGH3cdDlog90khhLv8J4Z/oDW
         S3LjdoB3Jd0acaSC2vJWeW7E4Z1FvzWkbTWJTa592BluNRvq/+o+Puv9L6+fpFXmQi
         4GUpYeB3ry9Mg==
Date:   Mon, 7 Feb 2022 21:50:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] ima: support fs-verity digests and signatures
Message-ID: <YgIEsLsoe/sHsjBr@sol.localdomain>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 07, 2022 at 08:41:32PM -0500, Mimi Zohar wrote:
> Support for including fs-verity file digests and signatures in the IMA
> measurement list as well as verifying the fs-verity file digest based
> signatures, both based on IMA policy rules, was discussed prior to
> fs-verity being upstreamed[1,2].
> 
> Support for including fs-verity file digests in the 'd-ng' template field
> is based on a new policy rule option named 'digest_type=verity'.  A new
> template field named 'd-type' as well as a new template named 'ima-ngv2'
> are defined to differentiate between the regular IMA file hashes from the
> fs-verity file digests (tree-hash based file hashes) stored in the 'd-ng'
> template field.
> 
> Support for verifying fs-verity based file signatures stored in the
> 'security.ima' xattr is similarly based on the policy rule option
> 'digest_type=verity'.
> 
> To differentiate IMA from fs-verity file signatures a new xattr_type
> named IMA_VERITY_DIGSIG is defined.  Signature version 3, which is a hash
> of the ima_file_id struct, disambiguates the signatures stored as
> 'security.ima' xattr.  fs-verity only supports the new signature format
> (version 3).  To prevent abuse of the different signature formats, policy
> rules must be limited to a specific signature version.
> 
> [1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
> [2] Documentation/filesystems/fsverity.rst

What does this patchset apply to?  I'm no longer able to apply it.  I tried
both v5.17-rc3, and the next-integrity branch of
https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git.

- Eric
