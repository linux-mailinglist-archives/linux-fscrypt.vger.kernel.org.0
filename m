Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F422F8855
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbhAOWTy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 17:19:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:35024 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbhAOWTy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 17:19:54 -0500
IronPort-SDR: AQ2QCrrm7kmrKOTVUT+61zCQD2MZV19X2xq+eim735y/vvHF0C6lMbarWeRN3X4Z2Qtpry2RF6
 EmHIS4ZzhJXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9865"; a="175110628"
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="175110628"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 14:19:12 -0800
IronPort-SDR: o+IHeP4AnwgrrLx/lXqSfNTp5obhJxaciuwq0Pyly94lafmC111MSBUe84bTT6LzKg0DGj8k4D
 57bxbl2RptPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="354465840"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.53])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2021 14:19:12 -0800
Date:   Fri, 15 Jan 2021 14:21:46 -0800
From:   Alison Schofield <alison.schofield@intel.com>
To:     linux-fscrypt@vger.kernel.org, Ben Boeckel <me@benboeckel.net>
Cc:     keyrings@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: Request_key from KMIP appliance
Message-ID: <20210115222145.GA24894@alison-desk>
References: <20210107213710.GA11415@alison-desk>
 <20210108003138.GB575130@erythro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108003138.GB575130@erythro>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


+ linux-fscrypt

Since I first wrote this question, realized we need to consider any
external key server, not only ones that are KMIP compliant.


On Thu, Jan 07, 2021 at 07:31:38PM -0500, Ben Boeckel wrote:
> On Thu, Jan 07, 2021 at 13:37:10 -0800, Alison Schofield wrote:
> > I'm looking into using an external key server to store the encrypted blobs
> > of kernel encrypted keys. Today they are stored in the rootfs, but we'd
> > like to address the need to store the keys in an external KMIP appliance,
> > separate from the platform where deployed.
> > 
> > Any leads, thoughts, experience with the Linux Kernel Key Service
> > requesting keys from an external Key Server such as this?
> 
> See the `request-key.conf(5)` manpage. I don't have experience with
> actual usage or deployment though, so others might have more input.
> 
> --Ben
