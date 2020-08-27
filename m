Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71670253B3D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Aug 2020 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0BAS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 21:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgH0BAR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 21:00:17 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B5DA20791;
        Thu, 27 Aug 2020 01:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598490017;
        bh=MuJK6Fq+nQHmaii7dvnYwwfnvKbk+kTDRV/j52dDGiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKgkjyjizAHqIEOeRAxxLaUn5tt7PDAwnqjns7AwvKMNXVmzm3mBAMGlDZuE0CilN
         SX3CfQPQtP5PAXoNxSvWfCSGMwbu/LL1CJEbDRgFR0/Ut13F3kP+cnbglGrmGscX+Q
         H/3PtTLYAT8bN8Z+tvLdeColWwcPQdKzaN1SK8cI=
Date:   Wed, 26 Aug 2020 18:00:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: IMA metadata format to support fs-verity
Message-ID: <20200827010016.GA2387969@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
 <20200826183116.GC2239109@gmail.com>
 <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
 <20200826192403.GD2239109@gmail.com>
 <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
 <20200826205143.GE2239109@gmail.com>
 <ced0c57308b0056396d4795a639e6d9686f0e163.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced0c57308b0056396d4795a639e6d9686f0e163.camel@linux.ibm.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 26, 2020 at 08:53:33PM -0400, Mimi Zohar wrote:
> On Wed, 2020-08-26 at 13:51 -0700, Eric Biggers wrote:
> > Of course, the bytes that are actually signed need to include not just the hash
> > itself, but also the type of hash algorithm that was used.  Else it's ambiguous
> > what the signer intended to sign.
> > 
> > Unfortunately, currently EVM appears to sign a raw hash, which means it is
> > broken, as the hash algorithm is not authenticated.  I.e. if the bytes
> > e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 are signed,
> > there's no way to prove that the signer meant to sign a SHA-256 hash, as opposed
> > to, say, a Streebog hash.  So that will need to be fixed anyway.  While doing
> > so, you should reserve some fields so that there's also a flag available to
> > indicate whether the hash is a traditional full file hash or a fs-verity hash.
> 
> The original EVM HMAC is still sha1, but the newer portable & immutable
> EVM signature supports different hash algorithms.
> 

Read what I wrote again.  I'm talking about the bytes that are actually signed.

- Eric
