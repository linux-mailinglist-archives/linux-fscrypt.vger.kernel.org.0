Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC8466C0C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbhLBWZa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:25:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39682 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhLBWZa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:25:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B70B823BF;
        Thu,  2 Dec 2021 22:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F158BC00446;
        Thu,  2 Dec 2021 22:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638483725;
        bh=m/Fk5iHRT7P9GXzIEh0mLfgphaEZn28dmq/GemN57M4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D2gqUcO76vhYh/jtJRmM4gtDyYzAkGlvYxJ+ZXHW/Pp6fh4lIMRTc5ZywduEon67N
         WWoxudSpr3WCOdakz9DWNled0AE/JUeoJKmlZLwGUfRPnHzCEDBF7Li6vAzlavenoY
         nzXVQjWQO+TRix6Ntnx5S2FcGtOAySyq9oduAqb9/KQW9kRvHS7xn1D0E5Ri/j6qh9
         lH0sTCLEsYL4rWcan7kmi0LuS7wFkC3S61eO/vKJLh7mflGyGNoqbXGUQqMbWvTLKh
         GCOkt6czMqYUvepFLTXpmz3nxg/vDg12dCzNXZtL5FcbelmcUiy8YZydSVExHwZzEJ
         Cy6Lvg1RR0ZIA==
Date:   Thu, 2 Dec 2021 14:22:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/5] ima: limit including fs-verity's file digest in
 measurement list
Message-ID: <YalHCz/FzQXKHx4u@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-4-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202215507.298415-4-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 04:55:05PM -0500, Mimi Zohar wrote:
> Without the file signature included in the IMA measurement list, the type
> of file digest is unclear.  Set up the plumbing to limit including
> fs-verity's file digest in the IMA measurement list based on whether the
> template name is ima-sig.  In the future, this could be relaxed to include
> any template format that includes the file signature.
> 

Does it make sense to tie IMA's fs-verity support to files having signatures?
What about IMA audit mode?  I thought that is just about collecting hashes, and
has nothing to do with signatures.

- Eric
