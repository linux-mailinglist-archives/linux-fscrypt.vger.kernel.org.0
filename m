Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABEA359028
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 01:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhDHXLq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 19:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhDHXLp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 19:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94668610CF;
        Thu,  8 Apr 2021 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617923493;
        bh=wdDCFqctavX1Z+bcng4n66iKuYteZhIwI+3qTqzMgAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZRI06xOe4HWEF9WlYfN4IhKPQtph0DNTC8FbjN6jFM8Dp1cNedR4cc9UdTKjpCoZ
         HMaETvSI15NXBCizFKEcXknMYU2STs2VYSavW1jc73z3nR6o+/DC4lA4/Kr/W9UZ70
         Dpy4MUmaqh1jlFbgoWR+e93vZUfJH6BVVetgOLma2JyT3fdbL2JRZKsL4lTU7AKk9F
         fDN2DYdXsa69aWaDEYnCV1JbZPHqX7Bb/HCfq6vzSitjYdhhyLAVGkPuBSMo7YSQtI
         3w8rZuqPOsY9UJB0uBHUJZ2GmZaEZbqmK1un3EQKl1T9jnji4mcxoB4ltLf2XHaB8H
         gl6KaPKIX8Uag==
Date:   Thu, 8 Apr 2021 16:11:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/3] btrfs: test btrfs specific fsverity corruption
Message-ID: <YG+NpE9rDWLTvy5G@sol.localdomain>
References: <cover.1617908086.git.boris@bur.io>
 <6e3759825cd0134186b0d6eb8825a4ba3ed62b70.1617908086.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3759825cd0134186b0d6eb8825a4ba3ed62b70.1617908086.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:57:49AM -0700, Boris Burkov wrote:
> +get_ino() {
> +	file=$1
> +	ls -i $file | awk '{print $1}'
> +}

Please use 'local' when declaring variables in shell functions.

> +# corrupt the data portion of an inline extent
> +corrupt_inline() {
> +	f=$SCRATCH_MNT/inl
> +	head -c 42 /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount

Isn't the sync unnecessary because the filesystem is unmounted anyway?

Likewise for all the other corrupt_* functions.

Otherwise, at a high level this test looks good -- thanks for writing it!

- Eric
