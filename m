Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478341EB00F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2020 22:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgFAUN7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jun 2020 16:13:59 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17177 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727996AbgFAUN7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jun 2020 16:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1591042429; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=SgvZHfHNtCuJtAN2Z4uiGj8mRTYf1LBCABGu+Y+ZHSsdc8JRS9Qg5IqtdqMXN2+OrtQVBhY6xBtXXiO+CPRTEo9FsGmHWugvglOp0J/JjQb/pmeSkLIK1IdtNore8oT1OPar4ffPYsPArSCYo+i5L1m1VOG6BafpnvnxIehvX8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1591042429; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=iHKvDhHs35LWXVBUJinfVWvxRNNT9gaqJMTFh6Khd4I=; 
        b=gP4SlAmoid03RswfLaz6EyXvE7cC/4pymHHdOjWYgfjOkxvQMCOmkKlUa93BTyVzlr7w8VCsKeTcF9O70pVoXnBhaOqx/UenWUFOWwFi9j5q3h1Em4boVR+HWH4ZXw3n+XrnIFCQ+OysofJTT1yH4vMt/Ks23QDPwTWxWl+nCXc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [100.109.160.239] (163.114.130.6 [163.114.130.6]) by mx.zoho.eu
        with SMTPS id 159104242691896.91440234977688; Mon, 1 Jun 2020 22:13:46 +0200 (CEST)
To:     linux-fscrypt@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@kernel.org>,
        Chris Mason <clm@fb.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: fsverity PAGE_SIZE constraints
Message-ID: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
Date:   Mon, 1 Jun 2020 16:13:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

I am working on adding fsverity support to RPM and I am hitting a tricky
problem. I am see this with RPM, but it really isn't specific to RPM,
and will apply to any method for distribution signatures.

fsverity is currently hard-wiring the Merkle tree block size to
PAGE_SIZE. This is problematic for a number of reasons, in particular on
architectures that can be configured with different page sizes, such as
ARM, as well as the case where someone generates a shared 'common'
package to be used cross architectures (noarch package in RPM terms).

For a package manager to be able to create a generic package with
signatures, it basically has to build a signature for every supported
page size of the target architecture.

Chris Mason is working on adding fsverity support to btrfs, and I
understand he is supporting 4K as the default Merkle tree block size,
independent of the PAGE_SIZE.

Would it be feasible to make ext4 and other file systems support 4K for
non 4K page sized systems and make that a general recommendation going
forward?

Thoughts?

Thanks,
Jes
