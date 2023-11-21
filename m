Return-Path: <linux-fscrypt+bounces-12-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F807F3A01
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 00:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4739CB21250
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898D854BE2;
	Tue, 21 Nov 2023 23:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjBoBc47"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E165101D;
	Tue, 21 Nov 2023 23:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2520EC433C8;
	Tue, 21 Nov 2023 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700607754;
	bh=7wHYwTI9XgX3j7L+DpuzfWRgi6PfmHTEm3GhMwKAqNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mjBoBc47paCrMPSROjDodxrmnWdopm62ist0cFHu55+JWPN98v0aIMB+caqKY22xS
	 3J1fk4geyNbha9GQMKAHu0a60Er3wPTvnOIL1QRi165BkQ79h8Jx/woWbOvZ//8VRF
	 Y/7cq4+DQSF5Zs71i57CAPQy7aMEnnD2pIti7KARQ8yVKUAOJQRg+7PXh4zV/tTa0w
	 IBa7RQRYhUHXm5LN+QImNE1C00aSe4piHz4XzZZ5H1cKH6Lqjae4qHiEXPxsXBBZ0V
	 pE0mZJyscuQuHpcG5HCYt6bn+nidf9DAueGg//5xvQA+lTsOiP62eC27xBxL+uByyO
	 2aekM1VmN4hWQ==
Date: Tue, 21 Nov 2023 15:02:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/36] btrfs: add fscrypt support
Message-ID: <20231121230232.GC2172@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>

On Tue, Oct 10, 2023 at 04:40:15PM -0400, Josef Bacik wrote:
> Hello,
> 
> This is the next version of the fscrypt support.  It is based on a combination
> of Sterba's for-next branch and the fscrypt for-next branch.  The fscrypt stuff
> should apply cleanly to the fscrypt for-next, but it won't apply cleanly to our
> btrfs for-next branch.  I did this in case Eric wants to go ahead and merge the
> fscrypt side, then we can figure out what to do on the btrfs side.
> 
> v1 was posted here
> 
> https://lore.kernel.org/linux-btrfs/cover.1695750478.git.josef@toxicpanda.com/

Hi Josef!  Are you planning to send out an updated version of this soon?

- Eric

