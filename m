Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D7504621
	for <lists+linux-fscrypt@lfdr.de>; Sun, 17 Apr 2022 04:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiDQCg7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 16 Apr 2022 22:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiDQCg7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 16 Apr 2022 22:36:59 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2118.outbound.protection.outlook.com [40.107.255.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930155BE77
        for <linux-fscrypt@vger.kernel.org>; Sat, 16 Apr 2022 19:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FF8PTGfAgezAXzNpsSW94wni+SYx3970qx9DNfh8o+9/f19ILVh8b2c4AOfbKKPtUYc4J/g06X//hUtrYtF2tXJyKnGu+zqzQaTmhQolU0NwVOza96Qn6LLlpX5EYMs2WxDy4k0rnCmQyIttW8zpJ+q1EZ6D0uUYUqsXCUvk6btmulEhpWkLKLljdKKEubY67vScIiTpfbNZkjZlnsqfUzKK0DGlYbfecrxv4/Zw5dIhFCLorZfV0mnWYRMUxxiguAWcjY42Fd0XoiIjENZV+XdLvvUohzfwozPrt3j7ZYh1rgT6PND3NXcot8/Fa80TvNB0GTrUC8A5NdW8HlsGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mvDYmXzZGmL9BvQ4YVaFYncRvGlsSOk2xczeBS3+5A=;
 b=HHiDjuGJ4V5snjh+08n/uztNs3yE924HF4+rl7JyUMJ8oId+jX/z2rze7hW+3zG3cSHLWOaBwXC9sSaTMUjuQLLzeovLJZDRWuLI+DBvGifizsSTHyTgKxCHK6Iw3db7x/V6qzKtbd7H/3p/hEZ9ncGh1PboQV5gLhDldGaKsftBMitORPH6LGQM4r4pkWJcgbdrlGCCy4c79lxrQgJGLjm6vZYyZ7J82SRW4B44vCzzWFWLWStaFEZYPJDBWXxyfQSRECYEc5lux7cJPvFQU6j35DcDkzEKELafdF3E+Pg/RqZeMwDgx66OuzNjdf2mBOqiJm5KL+XkDt5R7w8pnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mvDYmXzZGmL9BvQ4YVaFYncRvGlsSOk2xczeBS3+5A=;
 b=c2uMIra5gU3IN68o2E8M2UmHgxK9ydkKMjyjIcOVHOh3AZWs3jabap7PR1KYiQDyXb0TdKszGAi30Yt82YNNMFuzqn9dXYt/1NEG5SIVMZj+otZPEkujnJ9sJyOhCYKaXtnpq6EOtlnIstg1mEwihprzwgvqXGxH4KJHL0OuN0I=
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com (2603:1096:820:26::6)
 by TY2PR06MB3566.apcprd06.prod.outlook.com (2603:1096:404:105::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sun, 17 Apr
 2022 02:34:18 +0000
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::f0c7:9081:8b5a:7e7e]) by KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::f0c7:9081:8b5a:7e7e%8]) with mapi id 15.20.5164.025; Sun, 17 Apr 2022
 02:34:18 +0000
From:   =?utf-8?B?5bi45Yek5qWg?= <changfengnan@vivo.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: RE: why fscrypt_mergeable_bio use logical block number?
Thread-Topic: why fscrypt_mergeable_bio use logical block number?
Thread-Index: AdhQn4rHNxefpxbqR1m92HZ+oE4KkAAWhCGAAEIPx/A=
Date:   Sun, 17 Apr 2022 02:34:17 +0000
Message-ID: <KL1PR0601MB40035814CF8324474BC543B2BBF09@KL1PR0601MB4003.apcprd06.prod.outlook.com>
References: <KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com>
 <Ylm+VyMLzJ92yndr@gmail.com>
In-Reply-To: <Ylm+VyMLzJ92yndr@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af935a39-afe5-414d-59df-08da201ac590
x-ms-traffictypediagnostic: TY2PR06MB3566:EE_
x-microsoft-antispam-prvs: <TY2PR06MB35663DCDA5A93EA1DE8507E9BBF09@TY2PR06MB3566.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Hkw9SJiOlyBYDJcRSWnSvK37lcRwkGO/bkQ94mka6YVD7CBDR1WNgT4W02mNpgHh9PVAeEgsD4q9q5wOPu9+Yw/ofMZcF5DL0+qhspeJGsHeJWB88KsP1iLeRn6ocOLzvKu14JLOc85rA1vvKcoTMABJxlSLBnAIDqY4rSbDvIrXbVtaP3Vuby7vITjxcO6En+TAEg40easJAJ6uNVspYj5LV1/Oj/A9FHF+iPEm5MyS0JC2z2lo1YQTpCskGHVKq0WkrY4X6oufZQzxzYxQciuAqS0eS5chC2zB1gyos7jq9nUSeARzOl38KCC9a4S2oy1qitDGb15idn4spjltsShw/4dknRI7b2ERVJrmrmTY23Rt2vYJmobrbxlVehbkDOWZobk6TLS5nApVXqCjw0meJFGsM4OWnWv3MaVEnf3QeTgxCm47mGzkCmQZno/VYLO6MRKRc9N8JJaBY7yvkhwNNljZY/PKSJmgU3Sz5p1+I6iz4VE8uLEsLZ7ZjxH83wV8dDOz9f1rnwJVHIoTwnXem9Tk4rOMGd4X5MXUFx/2jujeIPtOfUwQvsY/QnuMRtCIcHB8ZNCFT5iu59ncnyz+cAxikaR76wkjnKsKbQD4wREU0RzOT3MNVGAVdn5lJ5RL0v5UlhM+NVcB+jpRaUQXSQuvJL+mTi12LjBxVezQHvKrMI+DcfXDU12wrdAgzKUXkCVkMmjst79Msn1Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4003.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(86362001)(52536014)(71200400001)(38070700005)(8936002)(26005)(186003)(83380400001)(66946007)(66556008)(66476007)(64756008)(66446008)(4326008)(8676002)(76116006)(7696005)(122000001)(85182001)(55016003)(54906003)(5660300002)(6916009)(38100700002)(316002)(53546011)(2906002)(6506007)(9686003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1pGaHJ6bDFXOVhNS1dleHpZR09FYTFqcmJnblo5cENLUWd0anhTcDNuOEQw?=
 =?utf-8?B?TDI3Z1ZHUG55bkNLd0lINzV6S20zeFhRV3hzdGZGdUNIaWJQSUIyWXk1TER3?=
 =?utf-8?B?Qk5McEhDdDZMM3o0TmRqNXFLeDRhbkdxcUdXcUxwbzByakpyRWw4UEZzZHVs?=
 =?utf-8?B?VkdYNXdQTVltaENsQjdua0ptREN6OXZKdVBsQnRaYTJXdGdWK3dlNjdET0Yz?=
 =?utf-8?B?MU5BNFlMbklUSnNrdERJWlBHeVp1QmtjUGowQVNJMW5yKytPNlZPNWp1cWNa?=
 =?utf-8?B?THI0TXBWcGl0R1g5NnpYVDJCbVF6VUg0YlJwMGR6N3BTU21jUG5OSE9xWnJq?=
 =?utf-8?B?c0JDMDhQRlFJWFFCNFlZZUU0Z3VrU1VXSnBGYk5Sdm9LQ1JmcHpVZ1VpTzVn?=
 =?utf-8?B?bFI4REcrZHRXaWFucmhNVXovYnpGaHNFbFFSdTVIcU9BS3o0QWxkYUJvYUx5?=
 =?utf-8?B?RXpUSEhSN2xzbkg4U1V6SklhOTRybzhpZTBBQzA2M3lHWjZpSVk0V1Q5Z3F0?=
 =?utf-8?B?WEYycnYyczBCbU54R3ptYm9PaVdwT0RHUnZuRUxRQ09xSGM2amwwUXAyd1dG?=
 =?utf-8?B?ZmIxckpqME9CS3JPa0ZoU2dYZmdZR00za28xMEtlZkprRlFYYlNLNldiNm9K?=
 =?utf-8?B?R204WUxRWnRzay9zTmlUTEpBeFd4eEZ5RnYvMUFDRlNMOEhqQWtuZ3h3Mllr?=
 =?utf-8?B?T1R0bWRjRnpLZlhnbHZSS3c5bjF0UkppazVSNGU0NUttNWx6RWFIalJnYXk3?=
 =?utf-8?B?RzdTcHlLUThUMy92WmxBNlBTTVh1NmtGOHNuUkxROWJ3ODdiQkNEMFMrVXF0?=
 =?utf-8?B?bGVEZGVLMjh0aWkyQ2d6TlZKWW5BN1hHa3pHblJqU2dRWnRzWGd1VTUzMWxT?=
 =?utf-8?B?K2s5YUpCN2phUlByVEJhS3NKOHNOWWRETUpIT1loVFB1bElKZ2lMK2ZwNERE?=
 =?utf-8?B?UnRxKythSkRzS1NQM0pnSysvRm5Bejl6SmhudTZlV3lhSExEQ3dDL1dYL0dG?=
 =?utf-8?B?bFh3NXRGMUFVWlVVV09QSjBxSkNzTkhQeGowNm5hRDNBa21ER3VrMjlCMlQy?=
 =?utf-8?B?RFN1YWVHRHF3cWI4SjZRRmFmaVkxQzVMQ0dpSFJlOTZQdlgvUUU3VTBnUXdm?=
 =?utf-8?B?Y1QzSld0V0FjaVh0MUx1azQ3UlpaQUJLdlJibnRaamVmdVI4Rms0dHIvTEpR?=
 =?utf-8?B?bUtWM1hTRG5KUFVNdXg5cFNUUzZwL3Z4UU11Z2JHYWpvWG9sMnRaN0RaQ3lE?=
 =?utf-8?B?NGorSHZSTENjZlJPK0J6b0ppckpiY3lVeWx2SmwvRGJDOVhJd1ExbERHQk84?=
 =?utf-8?B?cEg0Z20vRVprMS80RVJ2S2dtRGk3Y2N4TEx5Y2xKa2FmaUpKNVZTbkV1enVY?=
 =?utf-8?B?R1pjNnZEdklKYTdaYlNHWFVDdFJBSVR6OVk2VnlmVXhSOG56d3d5U1pHeEJC?=
 =?utf-8?B?Rk5HTDNCQmhJOUhHd3JqVjZkKzM3TXE4Uk1rQjFLR21hVFJnYnp5MmMrR0pi?=
 =?utf-8?B?TGhHQUJaK0JhZDMrMnB6cVBmSjhIWnRyUEp4TXJnYS9aOElVMkY1cmJVTnlr?=
 =?utf-8?B?OTlrcVQzWGRoZEkwQU9TQ3JBQ0lzT0dQMXFUWkRnVEFLc3h3akg3RVRtVDVG?=
 =?utf-8?B?bjM1NjRlTkRsN0lUYk51TjdtUFBiSEptSFBubS8zK3FZbkNNZCtSdFlYYmVZ?=
 =?utf-8?B?Qk9iVlFaQkhFMC92d0luVmF1cDRhRHBTWndzQUFQS1R4TVRRTTRGZHJhRmlt?=
 =?utf-8?B?aUhQN1pUVFJmSG1XRGFPcVpTaXQ5U2NPRmhPN3dZS0VzT3FBRldaU2dTUDZW?=
 =?utf-8?B?MUNEQlMxQm56SFo1cUhQT2JIWXZNMmRJVUVKYXp6TnpPZDIwRUJIcTdkeWJ2?=
 =?utf-8?B?VHVGTktGbVVQTDZpQU4rdGVoaWpQZTVIVlkxZDVvUy8vV1FhSFRMTVJJRXRh?=
 =?utf-8?B?TWNZUTN5NHJhTVoydkZISkpqRDVXcmhZVkNQQmw3Ry9hcUdhZS9FK3BDVW91?=
 =?utf-8?B?SG9oVjh1a3REbkF6NURtT0NkbWZHZ0NDYXdmRlNsMm54R1ZPN3hkVHZma0dP?=
 =?utf-8?B?SUxBQ2N4Y09JdjdmUXFEeW0zUFJnQmR5WEhJVFkyYVRRanR4U2hXQXp5bHVn?=
 =?utf-8?B?a21aSFZOeXE2eWE0NTBEVDY1RHc1KzgvTnBhcmsrOEdJQm9VK2daY2pkVSt2?=
 =?utf-8?B?NTNmQmhQWUpXc25Cend4WDhyUTVoUktGdWw4MmdxRHdkZEh2MjErSENpU0hm?=
 =?utf-8?B?THRCa2p4OWcyclVnVHkxRlRGSnlkNmJkZ0VkY2UyMFAzOE9USXJ2SFcxM2Za?=
 =?utf-8?Q?GuTIWkJAJuSmAQUTDN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4003.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af935a39-afe5-414d-59df-08da201ac590
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2022 02:34:17.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CpT8M/oBRKvUtlmKYyhPyBaZpDy1IZFXfwBc0TLSK870lEcHGxHdE/z0V7u0uRFkBYCUb+LqRdeMXxQFIB3jIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3566
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBCaWdnZXJzIDxl
YmlnZ2Vyc0BrZXJuZWwub3JnPg0KPiBTZW50OiBTYXR1cmRheSwgQXByaWwgMTYsIDIwMjIgMjo1
MCBBTQ0KPiBUbzog5bi45Yek5qWgIDxjaGFuZ2ZlbmduYW5Adml2by5jb20+DQo+IENjOiB0eXRz
b0BtaXQuZWR1OyBqYWVnZXVrQGtlcm5lbC5vcmc7IGxpbnV4LWZzY3J5cHRAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiB3aHkgZnNjcnlwdF9tZXJnZWFibGVfYmlvIHVzZSBsb2dpY2Fs
IGJsb2NrIG51bWJlcj8NCj4gDQo+IE9uIEZyaSwgQXByIDE1LCAyMDIyIGF0IDA4OjE4OjExQU0g
KzAwMDAsIOW4uOWHpOaloCB3cm90ZToNCj4gPiBIaToNCj4gPiAJV2hlbiBJIGRpZyBpbnRvIGEg
cHJvYmxlbSwgSSBmb3VuZDogYmlvIG1lcmdlIG1heSByZWR1Y2UgYSBsb3Qgd2hlbg0KPiA+IAll
bmFibGUgaW5saW5lY3J5cHQsIHRoZSByb290IGNhdXNlIGlzIGZzY3J5cHRfbWVyZ2VhYmxlX2Jp
byB1c2UgbG9naWNhbA0KPiA+IAlibG9jayBudW1iZXIgcmF0aGVyIHRoYW4gcGh5c2ljYWwgYmxv
Y2sgbnVtYmVyLiBJIGhhZCByZWFkIHRoZSBVRlNIQ0ksDQo+ID4gCWJ1dCBub3Qgc2VlIGFueSBk
ZXNjcmlwdGlvbiBhYm91dCB3aHkgZGF0YSB1bml0IG51bWJlciBzaG91ZCB1c2UNCj4gbG9naWNh
bA0KPiA+IAlibG9jayBudW1iZXIuIEkgd2FudCB0byBrbm93IHdoeSwgSXMgdGhlIGFueW9uZSBj
YW4gZXhwbGFpbiB0aGlzPw0KPiA+DQo+ID4gVGhhbmtzLg0KPiA+IEZlbmduYW4gQ2hhbmcuDQo+
IA0KPiBUaGUgbWFpbiByZWFzb24gdGhhdCBmc2NyeXB0IGdlbmVyYXRlcyBJVnMgdXNpbmcgdGhl
IGZpbGUgbG9naWNhbCBibG9jayBudW1iZXINCj4gaW5zdGVhZCBvZiB0aGUgc2VjdG9yIG51bWJl
ciBpcyBiZWNhdXNlIGYyZnMgbmVlZHMgdG8gbW92ZSBkYXRhIGJsb2Nrcw0KPiBhcm91bmQgd2l0
aG91dCB0aGUga2V5LiAgVGhhdCB3b3VsZCBiZSBpbXBvc3NpYmxlIHdpdGggc2VjdG9yIG51bWJl
cg0KPiBiYXNlZCBlbmNyeXB0aW9uLg0KU28gaWYgdXNlIHNlY3RvciBudW1iZXIgdG8gZ2VuZXJh
dGUgSVZzLCBhZnRlciBmMmZzIG1vdmUgZGF0YSBibG9ja3MgaW4gZ2MsIHdlIGNhbg0Kbm90IGRl
Y3J5cHQgY29ycmVjdGx5LCBhbSBJIHJpZ2h0ID8NCj4gDQo+IFRoZXJlIGFyZSBvdGhlciByZWFz
b25zIHRvby4gIEFsd2F5cyB1c2luZyB0aGUgZmlsZSBsb2dpY2FsIGJsb2NrIG51bWJlcg0KPiBr
ZWVwcyB0aGUgdmFyaW91cyBmc2NyeXB0IG9wdGlvbnMgY29uc2lzdGVudCwgaXQgd29ya3Mgd2Vs
bCB3aXRoIHBlci1maWxlIGtleXMsIGl0DQo+IGRvZXNuJ3QgYnJlYWsgZmlsZXN5c3RlbSByZXNp
emluZywgYW5kIGl0IGF2b2lkcyBoYXZpbmcgdGhlIGludGVycHJldGF0aW9uIG9mDQo+IHRoZSBm
aWxlc3lzdGVtIGRlcGVuZCBvbiBpdHMgb24tZGlzayBsb2NhdGlvbiB3aGljaCB3b3VsZCBiZSBh
IGxheWVyaW5nDQo+IHZpb2xhdGlvbi4gIEJ1dCB0aGUgbmVlZCB0byBzdXBwb3J0IGYyZnMgaXMg
dGhlIG1haW4gb25lLg0KPiANCj4gTm90ZSB0aGF0IGJ5IGRlZmF1bHQsIGZzY3J5cHQgdXNlcyBh
IGRpZmZlcmVudCBrZXkgZm9yIGV2ZXJ5IGZpbGUsIGFuZCBpbiB0aGF0IGNhc2UNCj4gdGhlIG9u
bHkgd2F5IHRoYXQgdXNpbmcgdGhlIGZpbGUgbG9naWNhbCBibG9jayBudW1iZXIgaW5zdGVhZCBv
ZiB0aGUgc2VjdG9yDQo+IG51bWJlciB3b3VsZCBwcmV2ZW50IG1lcmdpbmcgaXMgaWYgZGF0YSB3
YXMgYmVpbmcgcmVhZC93cml0dGVuIGZyb20gYSBmaWxlDQo+IHRoYXQgaXMgcGh5c2ljYWxseSBi
dXQgbm90IGxvZ2ljYWxseSBjb250aWd1b3VzLiAgVGhhdCdzIG5vdCBhIHZlcnkgY29tbW9uDQo+
IGNhc2UuDQpUaGlzIGlzIGV4YWN0bHkgdGhlIHByb2JsZW0gSSBoYXZlIGZhY2VkLiBXZSByZWFk
L3dyaXRlIGEgZmlsZSBpbiBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgYnV0IG5vdCBsb2dpY2FsbHku
DQpTbyBJJ20gd2FuZGVyIGlmIHdlIGNhbiBrZWVwIHBoeXNpY2FsbHkgY29udGlndW91cyBhbHdh
eXMsIGNhbiB3ZSBza2lwIGNoZWNrIHdoZWF0ZWFyIGxvZ2ljYWwgYmxvY2sgDQpudW1iZXIgaXMg
Y29udGlndW91cyB3aGVuIGJpbyBtZXJnZT8NCj4gDQo+IC0gRXJpYw0K
