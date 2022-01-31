Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50C94A5012
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Jan 2022 21:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbiAaUYj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 15:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiAaUYj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 15:24:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCDCC061714;
        Mon, 31 Jan 2022 12:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527E6B82AD8;
        Mon, 31 Jan 2022 20:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF76DC340EE;
        Mon, 31 Jan 2022 20:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643660676;
        bh=9/QuV8L/gr5yVxdO/V8Khqbezdo+Qze0AFkJourSvdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PasuRZ82+odQ06j2h86smPO/t57h2rTubzX4HfkV9uHUS/EM8cV1QytZZPmM9fqIE
         quZjLJ10FiMcc+x/8pHe8qzsNb+yzfvt7DSpZIOjCV9Akhz8LpOYpmG/EqNommlrjW
         JzhK9XPgCeqCkLYaAUOsnTq1ldRYZl3do9JPjwIpV9TrW40UtAi7IGFW05W3eCSakm
         lquaZaCDTV7lLgGPmmb+QaWVMePmqKVmuQW1I+9pDGwdE8612WKoua2gfzXbKhXFDK
         iHD2fNYUSAPvXsljeC46gx7m0MeeF7CO0T5vE6ll3hTuyIXWT140MjpORS5VFgOeSa
         ESZBLWxG1YqnQ==
Date:   Mon, 31 Jan 2022 20:24:34 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Message-ID: <YfhFgtg4X1DLJtAQ@gmail.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain>
 <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
 <YfRRUBZpQv2Hi1sL@sol.localdomain>
 <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
 <b262cb06-37fd-9760-8f6e-1dcacbf738b4@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b262cb06-37fd-9760-8f6e-1dcacbf738b4@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 31, 2022 at 02:29:19PM -0500, Stefan Berger wrote:
> > > don't think I realized there was a more direct, PKCS#7-less way to do it and
> > > that IMA used that way.)  However, it would be better to use this as an
> > > opportunity to move people off of the built-in signatures entirely, either by
> > > switching to a full userspace solution or by switching to IMA.
> > If what we sign remains the same, then we could support multiple
> > methods and use a selector to let fsverity_verify_signature() know
> > how it should verify the signature. I don't know what would be a
> > proper place for the selector.
> > 
> > PKCS#7 seems ok, as it is used for kernel modules. IMA would be
> > also ok, as it can verify the signature more directly. I would also
> > be interested in supporting PGP, to avoid the requirement for
> > Linux distributions to manage a secondary key. I have a small
> > extension for rpmsign, that I would like to test in the Fedora
> > infrastructure.
> > 
> > Both the PKCS#7 and the PGP methods don't require additional
> > support from outside, the functions verify_pkcs7_signature()
> > and verify_pgp_signature() (proposed, not yet in the upstream
> > kernel) would be sufficient.
> 
> FYI: An empty file signed with pkcs7 and an ecc key for NIST p256 generates
> a signature of size 817 bytes. If an RPM needs to carry such signatures on a
> per-file basis we are back to the size increase of nearly an RSA signature.
> I would say for packages this is probably too much size increase.. and this
> is what drove the implementation of ECC support.

I am getting 256 bytes for an ECC signature in PKCS#7 format:

	cd src/fsverity-utils
	make
	openssl ecparam -name prime256v1 -genkey -noout -out key.pem
	openssl req -new -x509 -key key.pem -out cert.pem -days 360
	touch file
	./fsverity sign file file.sig --key=key.pem --cert=cert.pem
	stat -c %s file.sig

Probably you accidentally included the whole certificate in the PKCS#7 message.
That's not required here.

There are definitely problems with PKCS#7, and it does have space overhead.  But
the space overhead is not as bad as you state.

- Eric
