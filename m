Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC4249EB30
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 20:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiA0Tjm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 14:39:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240050AbiA0Tjl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 14:39:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B1B561DEA;
        Thu, 27 Jan 2022 19:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B52EC340E4;
        Thu, 27 Jan 2022 19:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643312380;
        bh=owz65Zoh9kePy3ZlX07GkhDAStAtpMEoESAaQC2QOkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mbfVmo2uqo+8GEh0l5KWQwAIV2xmvPtlCTVlp8ccJt8YTEZQcI/WoEKvZVePzpgbq
         x92AWWjGEfEZ6wTefiKgujv8nQ9eM6pFEhOJWJ2Os58tO7UYH6EEBzYQmHGWHeggTt
         PLCEVTsp3l+AqG++CrcNAr+N6ml8NMZq+O0W0Z6uZn3xGFvvDTKiOIf6k9Bns64jmu
         W9w0/AB4fThsGCU6iQGjTxBjwBedFu9YT4ab0Hjcdgot+wRAFeTiqONtHDnHXZ3t2z
         RtmZS0TvtETw9nBCYTPlZcHHleGGs31cyplLrh7ZJOROF1YLR1nu1UdejuMHYPxGOB
         UaeP+PRVLpJsQ==
Date:   Thu, 27 Jan 2022 11:39:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org, zohar@linux.ibm.com,
        stefanb@linux.ibm.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Message-ID: <YfL0+q/ekv4H8lZg@sol.localdomain>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfLz8NftvbZtKvLT@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
> On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> > I wanted to propose a different approach for handling fsverity digests and
> > signatures, compared to:
> > 
> > https://lore.kernel.org/linux-integrity/20220126000658.138345-1-zohar@linux.ibm.com/
> > 
> > In the original proposal, a new signature version has been introduced (v3)
> > to allow the possibility of signing the digest of a more flexible data
> > structure, ima_file_id, which could also include the fsverity file digest.
> > 
> > While the new signature type would be sufficient to handle fsverity file
> > digests, the problem is that its format would not be compatible with the
> > signature format supported by the built-in verification module in fsverity.
> > The rpm package manager already has an extension to include fsverity
> > signatures, with the existing format, in the RPM header.
> > 
> > Given that the fsverity signature is in the PKCS#7 format, IMA has already
> > the capability of handling it with the existing code, more specifically the
> > modsig code. It would be sufficient to provide to modsig the correct data
> > to avoid introducing a new signature format.
> 
> I think it would be best to get people moved off of the fs-verity built-in
> signatures, rather than further extend the use of it.  PKCS#7 is a pretty
> terrible signature format.  The IMA one is better, though it's unfortunate that
> IMA still relies on X.509 for keys.

Note, the only reason that support for fs-verity built-in signatures was added
to RPM is that people didn't want to use IMA:
https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com

If people are going to use IMA anyway, then there would be no point.

- Eric
