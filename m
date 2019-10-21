Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06AEDF6B9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2019 22:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfJUU2O (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 16:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUU2O (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 16:28:14 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95FF12067B;
        Mon, 21 Oct 2019 20:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571689693;
        bh=yuyYH5txUJFQLMmsUgKioVsaetUA4KvG58kwl612GrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=an64t09Xy6VRXqPUL3GAIscODkfzQVFm3dpCFD2yIaAOE6cETIfhBMD87q+snEVE5
         Rom5MN9qzxQyKuQxxFpZ/OaBDo1FMMMEv9GyNL58gw4pnsTnZfAmj0n8bJyss80aop
         /MWy7freDt/FEOXG2dZ+xcYBu84nosqqtIrbVFc0=
Date:   Mon, 21 Oct 2019 13:28:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: Re: [PATCH] fscrypt: remove struct fscrypt_ctx
Message-ID: <20191021202811.GB122863@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Chandan Rajendra <chandan@linux.ibm.com>
References: <20191009234038.224587-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009234038.224587-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 09, 2019 at 04:40:38PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that ext4 and f2fs implement their own post-read workflow that
> supports both fscrypt and fsverity, the fscrypt-only workflow based
> around struct fscrypt_ctx is no longer used.  So remove the unused code.
> 
> This is based on a patch from Chandan Rajendra's "Consolidate FS read
> I/O callbacks code" patchset, but rebased onto the latest kernel, folded
> __fscrypt_decrypt_bio() into fscrypt_decrypt_bio(), cleaned up
> fscrypt_initialize(), and updated the commit message.
> 
> Originally-from: Chandan Rajendra <chandan@linux.ibm.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git for 5.5.

- Eric
