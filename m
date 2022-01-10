Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46F048A292
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 23:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345300AbiAJWPq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jan 2022 17:15:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345293AbiAJWPp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jan 2022 17:15:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C803D60DBF;
        Mon, 10 Jan 2022 22:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F72C36AE3;
        Mon, 10 Jan 2022 22:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641852944;
        bh=V2Zjw5W6p93DG2iC85/vjKbGVhI9gUdRSgYRCp2L7gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dwl1LcZEtMd79IyL5CKtumJpiIWW1L6wYq61OFKxSZsupM1dCgXrx11KK1Z9ZYVV/
         fBUHVOg0KU+Xk40E4JizUi4McNFStS1GvVy41f1dOqrC4WDzlKz7W7C1U8nHG1YF+M
         Io9uuNORCmym/aa/2P0VrUHmHbH0nUmVwEjl6tnS6/ekWfSdQLvmTGMMHB70vk4+oU
         TIiA9LS/GvUZU6zAlDGp5GwstsdmvZ/2hGiYRrl/J6BpVPRWXSJPJbATx+4/ylk0QE
         5w8aSAmdHF1wjEYGBk74CQI+V1MQUoShrvhi9oTcoUywgi3bHR/dKJGDjRHkEI41cP
         8kdDmbm3fD+Yw==
Date:   Mon, 10 Jan 2022 14:15:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] fs-verity: define a function to return the
 integrity protected file digest
Message-ID: <YdywDmBl0u55Qod0@gmail.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
 <20220109185517.312280-3-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109185517.312280-3-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 09, 2022 at 01:55:13PM -0500, Mimi Zohar wrote:
> Define a function named fsverity_get_digest() to return the verity file
> digest and the associated hash algorithm (enum hash_algo).
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---

Acked-by: Eric Biggers <ebiggers@google.com>

> +int fsverity_get_digest(struct inode *inode,
> +			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> +			    enum hash_algo *alg)

There's some weird indentation here.

- Eric
